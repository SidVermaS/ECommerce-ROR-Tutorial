require 'rails_helper'

describe "Books API", type: :request do
    let(:first_author)  {
        FactoryBot.create(:author, first_name: "JS", last_name: "Author", age: 25)
    }
    let(:second_author) {
        FactoryBot.create(:author, first_name: "Go", last_name: "Author", age: 12)
    }
    describe "GET /books" do
        before(:each) do
            FactoryBot.create(:book, title: "JS Book", author: first_author)
            FactoryBot.create(:book, title: "Go Book", author: second_author)
        end
        it "returns all books" do
            get "/api/v1/books"

            expect(response).to have_http_status(:ok)
            # expect(response).to have_http_status(:success)
            # expect(JSON.parse(response.body).size).to be > 1
            
            
            expect(response_body.size).to eq(2)
            expect(response_body).to eq([
                {
                    "id" => 1,
                    "title" => "JS Book",
                    "author_name" => "JS Author",
                    "author_age" => 25
                },
                {
                    "id" => 2,
                    "title" => "Go Book",
                    "author_name" => "Go Author",
                    "author_age" => 12
                },
            ])
        end

        it "returns a subset of books based on limit" do
            get "/api/v1/books", params: { limit: 1 }

            expect(response).to have_http_status(:ok)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [
                    {
                        "id" => 1,
                        "title" => "JS Book",
                        "author_name" => "JS Author",
                        "author_age" => 25
                    }
                ]
            )
        end

        it "returns a subset of books based on limit and offset" do
            get "/api/v1/books", params: { limit: 1, offset: 1 }

            expect(response).to have_http_status(:ok)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [
                    {
                        "id" => 2,
                        "title" => "Go Book",
                        "author_name" => "Go Author",
                        "author_age" => 12
                    }
                ]
            )
        end

        it "has max limit of 100" do
            expect(Book).to receive(:limit).with(100).and_call_original
            get "/api/v1/books", params: { limit: 100 }          
        end
    end

    describe "POST /books" do
        let!(:user) { FactoryBot.create(:user, password: "Password1") }

        it "create a new book" do
            expect {
                post "/api/v1/books", 
                params: { 
                    book: { title: "Dart Book", },
                    author: { first_name: "Dart", last_name: "Author", age: 7 }
                },
                headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" } 
            }.to change { Book.count }.from(0).to(1)
            expect(response).to have_http_status(:created)
            expect(Author.count).to eq(1)
            expect(response_body).to eq(
                {
                    "id" => 1,
                    "title" => "Dart Book",
                    "author_name" => "Dart Author",
                    "author_age" => 7
                }
            )
        end
    end

    describe "DELETE /books" do
        let!(:book) {
            FactoryBot.create(:book, title: "JS Book", author: first_author)
        }
        let!(:user) {
            FactoryBot.create(:user, { password: "Password1" })
        }
        it "deletes a book" do
            delete "/api/v1/books/#{book.id}",
            headers: {
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
            }
            expect(response).to have_http_status(:no_content)
        end
    end
end