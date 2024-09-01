require "net/http"
class UpdateSkuJob < ApplicationJob
  queue_as :default

  def perform(book_title)
    # Do something later
    uri = URI("http://localhost:4567/update_sku")
    uri = URI("https://api.github.com/users/SidVermaS")

    req = Net::HTTP::Get.new(uri, "ContentType" => "application/json")
    req.body = { sku: "123", title: book_title, }.to_json
    _res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(req)
    end

    # puts "2222 res"
    # puts _res.body
  end
end
