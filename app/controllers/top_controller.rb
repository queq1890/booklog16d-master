class TopController < ApplicationController
  before_action :admin_user,only:[:new, :create]

  def index
    @reviews = Review.all
    @review_books = []
    @review_books_results = []

    @bookmarks = Bookmark.all.order("id DESC")
    @bookmark_books = []
    @bookmark_books_results = []

    @ranking_books = []
    @ranking_books_results = []


    @reviews.each do |review|
      openBD_uri = URI.parse('https://api.openbd.jp/v1/get?isbn=' +"#{ review.isbn}")
      openBD_json = Net::HTTP.get(openBD_uri)
      openBD_result = JSON.parse(openBD_json).to_a

      @review_books << openBD_result
    end


    @review_books.each_with_index do |data, i|
      if data.present?
        item = Item.new(isbn: data[0]["summary"]["isbn"],
                        name: data[0]["summary"]["title"],
                        image: data[0]["summary"]["cover"],
                        author: data[0]["summary"]["author"],
                        publisher: data[0]["summary"]["publisher"],
                        release_date: data[0]["summary"]["pubdate"])
        @review_books_results << item
      end
    end

    @bookmarks.each do |bookmark|
      openBD_uri = URI.parse('https://api.openbd.jp/v1/get?isbn=' +"#{ bookmark.isbn}")
      openBD_json = Net::HTTP.get(openBD_uri)
      openBD_result = JSON.parse(openBD_json).to_a

      @bookmark_books << openBD_result
    end

    @bookmark_books.each_with_index do |data, i|
      if data.present?
        item = Item.new(isbn: data[0]["summary"]["isbn"],
                        name: data[0]["summary"]["title"],
                        image: data[0]["summary"]["cover"],
                        author: data[0]["summary"]["author"],
                        publisher: data[0]["summary"]["publisher"],
                        release_date: data[0]["summary"]["pubdate"])
        @bookmark_books_results << item
      end
    end
    @bookmark_books_results.uniq!{|n| n.name}

    ranking_isbn_lists = Bookmark.group(:isbn).order('count_isbn DESC').count(:isbn).keys
    ranking_isbn_lists.each do |isbn|
      openBD_uri = URI.parse('https://api.openbd.jp/v1/get?isbn=' +"#{isbn}")
      openBD_json = Net::HTTP.get(openBD_uri)
      openBD_result = JSON.parse(openBD_json).to_a

    @ranking_books << openBD_result
    end

    @ranking_books.each_with_index do |data, i|
      if data.present?
        item = Item.new(isbn: data[0]["summary"]["isbn"],
                        name: data[0]["summary"]["title"],
                        image: data[0]["summary"]["cover"],
                        author: data[0]["summary"]["author"],
                        publisher: data[0]["summary"]["publisher"],
                        release_date: data[0]["summary"]["pubdate"])
        @ranking_books_results << item
      end
    end
  end

private

  def admin_user
    redirect_to :root unless current_user.admin?
  end
end
