class MoviesController < ApplicationController
  before_action :require_movie, only: [:show]

  def index
    data = Movie.all
    render status: :ok, json: data.as_json(only: [:id, :title, :release_date])
  end

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:id, :title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
        )
      )
  end

  def create
    movie = Movie.new(params.permit(:title, :overview, :release_date, :inventory))
    if movie.save
      render(
        status: :ok,
        json: { id: movie.id }
      )
    else
      render(
        status: :bad_request,
        json: { errors: movie.errors.messages }
      )
    end
  end

private
  def require_movie
    @movie = Movie.find_by(id: params[:id])
    unless @movie
      render status: :not_found, json: { errors: { id: ["No movie with id #{params["id"]}"] } }
    end
  end
end
