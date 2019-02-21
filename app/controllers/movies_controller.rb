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
    
    @clicked_box = params[:ratings] || session[:ratings] || nil
        
    # Hash to hold the check box values of the ratings
    if @clicked_box == nil
      @clicked_box = Hash[@all_ratings.map{|rating| [rating, rating]}]
    end
    
    if params[:sort_val] != session[:sort_val] or params[:ratings] != session[:ratings]
      session[:sort_val] = params[:sort_val] || session[:sort_val]
      session[:ratings] = @clicked_box
      redirect_to movies_path(ratings: @clicked_box, sort: session[:sort_val])
    end
    
    # Sort according to title or release date
    if params[:sort_val] || session[:sort_val] == "title"
 	    @title_sort = session[:title_sort] = "hilite"
 	    @movies = Movie.where(rating: @clicked_box.keys).order("title")
    elsif params[:sort_val] || session[:sort_val] == "release_date"
      @release_date_sort = session[:release_date_sort] = "hilite"
      @movies = Movie.where(rating: @clicked_box.keys).order("release_date")
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
