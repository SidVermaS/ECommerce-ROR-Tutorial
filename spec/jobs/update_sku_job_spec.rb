require 'rails_helper'

RSpec.describe UpdateSkuJob, type: :job do
  let(:book_title)  {
    "Dart Book"
  }
  before(:each) do
    allow(Net::HTTP).to receive(:start).and_return(true)
  end
  it "calls SKU service with correct params" do
    expect_any_instance_of(Net::HTTP::Get).to receive(:body=).with({ sku: "123", title: \ }.to_json)

    described_class.perform_now(book_title)
  end
end
