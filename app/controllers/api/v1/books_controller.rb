require "net/http"

module Api
  module V1
    # class Api::V1::BooksController
    class BooksController < ApplicationController
      include ActionController::HttpAuthentication::Token
      MAX_PAGINATION_LIMIT = 100

      before_action :authenticate_user, only: [ :create, :destroy ]
      
      def index()
        # render json: Book.all()

        books = Book.limit(limit).offset(params[:offset])

        render json: BooksRepresenter.new(books).as_json
      end

      def create
        # binding.irb
        # book = Book.new(title: params[:title], author: params[:author])
        # book = Book.new(book_params)
        
        author = Author.create!(author_params)
        book = Book.new(book_params.merge(author_id: author.id))

        # uri = URI("http://localhost:4567/update_sku")
        # req = Net::HTTP::Post.new(uri, "Content-Type"=>"application/json")
        # req.body = { sku: "123", name: book_params[:name] }
        # _res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        #   http.request(req)
        # end
        # raise "exit"

        UpdateSkuJob.perform_later(book_params[:title])

        if book.save
          render json: BookRepresenter.new(book).as_json, status: :created
        else
          render json: book.errors, status: :unprocessable_entity
        end
      end

      # def destroy
      #   begin
      #     Book.find(params[:id]).destroy!
      #     head :no_content
      #   rescue ActiveRecord::RecordNotFound => exception
      #     render json: {error: exception}, status: :unprocessable_entity
      #   end
      # end

      def destroy
        Book.find(params[:id]).destroy!
        head :no_content
      end

      def authenticate_user
        token, _options = token_and_options(request)
        user_id = AuthenticationTokenService.decode(token)
        User.find(user_id)
        rescue ActiveRecord::RecordNotFound, JWT::DecodeError
          head :unauthorized
      end   

      def limit
        [
          params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i,
          MAX_PAGINATION_LIMIT
        ].min
      end

      def author_params()
        params.require(:author).permit(:first_name, :last_name, :age)
      end
      def book_params()
        params.require(:book).permit(:title, :author)
      end
    end
  end
end