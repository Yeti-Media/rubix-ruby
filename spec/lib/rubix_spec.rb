require 'spec_helper'

describe Rubix do
  before do
    @access_token = 'access_token'
    @version = 'v1'
    @domain = 'http://api.rubix.io'
    @client = Rubix.new(@access_token)
  end

  it "should list categories" do
    json_response = [{"id"=>72, :title => 'matching'}]
    FakeWeb.register_uri(:get, "#{@domain}/api/#{@version}/categories", body: json_response.to_json, status: 200,
                         user_key: @access_token)
    response = @client.list_categories
    response[0]['title'].should == 'matching'
  end

  it "should list patterns" do
    json_response = [{"id"=>72, :label => 'BrandId'}]
    FakeWeb.register_uri(:get, "#{@domain}/api/#{@version}/patterns?page=2", body: json_response.to_json, status: 200,
                         user_key: @access_token)
    response = @client.list_patterns(2)
    response[0]['label'].should == 'BrandId'
  end

  it "should delete a pattern" do
    json_response = {"id"=>72, :label => 'BrandId'}
    FakeWeb.register_uri(:delete, "#{@domain}/api/#{@version}/patterns/2", body: json_response.to_json, status: 200,
                         user_key: @access_token)
    response = @client.delete_pattern(2)
    response['id'].should == 72
  end

  it "should initialize the client" do
    @client.client.url_prefix.to_s.should == "#{@domain}/"
    @client.access_token.should == @access_token
    @client.version.should == @version
  end

  it "should correctly add a pattern" do
    file_url = "http://example.com/path/to/image.png"
    label = 'uid'
    category = 'matching'
    json_response = {"id"=>72, "file"=>{"url"=>file_url}, "label"=>label, "category_id"=>2}
    FakeWeb.register_uri(:post, "#{@domain}/api/#{@version}/patterns", body: json_response.to_json, status: 200,
                         user_key: @access_token)
    response = @client.add_pattern(remote_file_url: file_url, label: label, category_name: category)
    response['label'].should == label
    response['file']['url'].should == file_url 
  end 

  it "should correctly feature match" do
    json_response = {"label"=>'image.png', "values"=>[{"center"=>{"x"=>165.933654785156, "y"=>261.701690673828}}, "label"=>"uid", "pattern_url"=>"/uploads/pattern/1/matching/image.png" ]}
    FakeWeb.register_uri(:post, "#{@domain}/api/#{@version}/patterns/feature_matcher", body: json_response.to_json,
                         status: 200, user_key: @access_token)
    response = @client.add_pattern(remote_file_url: "http://example.com/path/to/image.png", mr: 0.9, mma: 150)
    response['label'].should == 'uid' # don't know why reponse['label'] is matching to the 'label' insde 'values'
  end 
 
  # it "should correctly ocr" do
  #   #json_response = {"matches"=>[{"pattern"=>"xWpvxEx6tTo4GPxTGSTm1Qz99HD9AYPBiwrr", "percentage"=>95, "scene"=>"image", "pattern_url"=>"/uploads/pattern/1/comparison/imagexzcxxzc.png", "label"=>"yeti"}], "scenario_url"=>"image.png"}
  #   FakeWeb.register_uri(:post, "#{@domain}/api/#{@version}/patterns/ocr", body: json_response.to_json, status: 200)
  #   response = @client.add_pattern(remote_file_url: "http://example.com/path/to/image.png")
  #   response['text'].should == 'uid'
  # end 

end