class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    if (Movie.exists?id)   #to handle going back after deleting id
      @movie = Movie.find(id) # look up movie by unique ID
    else
      redirect_to movies_path(:field=>@field, :ratings=>@ratings)
    end  
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    #session.clear
    @all_ratings = Movie.all_ratings
    @field = params[:field] || session[:field]
    @all_ratings_with_hash = Hash[@all_ratings.collect { |v| [v, 1] }]
    
    if(params[:ratings])
      @ratings = params[:ratings]
    else
      @ratings = session[:ratings] || @all_ratings_with_hash
    end
    
    if (@field != params[:field] or @ratings != params[:ratings])
      flash.keep
      redirect_to movies_path(:field=>@field, :ratings=>@ratings)
    end
    @movies = Movie.where({rating:@ratings.keys}).order(@field);
    
    session[:field]=@field
    session[:ratings]=@ratings
    
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
