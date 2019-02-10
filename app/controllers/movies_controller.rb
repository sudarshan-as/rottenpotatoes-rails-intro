class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    
    @movies = Movie.all
    
    if params[:ratings]
      @ratings_filter = params[:ratings].keys
    else
      if session[:ratings]
        @ratings_filter = session[:ratings].keys
      else
        @ratings_filter = @all_ratings
      end
    end
    
    if @ratings_filter!=session[:ratings]
      session[:ratings] = @ratings_filter
    end
    
    @movies = @movies.where('rating in (?)', @ratings_filter)
    
    if params[:sort]
      @sorting = params[:sort]
    else
      @sorting = session[:sort]
    end
    
    if @sorting != session[:sort]
      session[:sort] = @sorting
    end
    
    if @sorting == 'title'
      @movies = @movies.order(@sorting)
      @title_sort = 'hilite'
    elsif @sorting == 'release_date'
      @movies = @movies.order(@sorting)
      @release_date_sort = 'hilite'
    else
      @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
