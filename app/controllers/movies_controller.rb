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
      sort = params[:sort] || session[:sort]
	    @movies = Movie.all
	    @all_ratings = ['G','PG','PG-13','R']
	    @clicked_box = params[:ratings] || session[:ratings] || {}
	    if @clicked_box == {}
	      @clicked_box = Hash[@all_ratings.map {|rating| [rating, rating]}]
	    end
	    
	    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
	      session[:sort] = sort
	      session[:ratings] = @clicked_box
	      redirect_to :sort => sort, :ratings => @clicked_box and return
	    end
	    if sort == 'title'
	      @movies = Movie.where(rating: @clicked_box.keys).sort_by { |h | h[:title] }
	    elsif sort == 'release_date'
	      @movies = Movie.where(rating: @clicked_box.keys).sort_by { |h | h[:release_date] }
	    else
	      @movies = Movie.where(rating: @clicked_box.keys)
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
