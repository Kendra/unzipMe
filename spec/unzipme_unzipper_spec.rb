require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UnzipmeUnzipper do

  it "raises an exception unless a file is provided" do
    expect {UnzipmeUnzipper.new(nil)}.to raise_error(ArgumentError, "You must provide a file.")
  end


  private

  def mock_file
    mock(File)
  end

  def mock_directory
    mock(Dir)
  end


end
