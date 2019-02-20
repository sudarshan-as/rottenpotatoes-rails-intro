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
        @ratings_filter = session[:ratings]
      else
        @ratings_filter = @all_ratings
      end
    end
    
    if @ratings_filter!=session[:ratings]
      session[:ratings] = @ratings_filter
    end
    @movies = @movies.where('rating in (?)', @ratings_filter)
    
    if params[:sort_val] == "title"
 	    @title_sort = session[:title_sort] = "hilite"
 	    @release_date_sort = session[:release_date_sort] = ""
 	    @movies = Movie.order("title")
    elsif params[:sort_val] == "release"
      @release_date_sort = session[:release_date_sort] = "hilite"
      @title_sort = session[:title_sort] = ""
      @movies = Movie.order("release_date")
    else
 	    @movies = Movie.all
    end
    
    if session[:title_sort]=="hilite" && params[:sort_val]==nil 
      params[:sort_val] = "title"
      redirect_to movies_path(params)
    elsif session[:release_date_sort]=="hilite" && params[:sort_val]==nil
      params[:sort_val] = "release"
      redirect_to movies_path(params)
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
