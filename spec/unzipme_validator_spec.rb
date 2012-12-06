require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UnzipmeValidator do

  it "should raise an ArgumentError if initialized with nil" do
    expect {UnzipmeValidator.new(nil)}.to raise_error(ArgumentError, "You must provide a file.")
  end



end
