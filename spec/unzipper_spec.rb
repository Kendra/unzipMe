require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Unzipper do

  it "raises an exception unless a file are provided" do
    expect {Unzipper.unzip(nil, nil)}.to raise_error(UnzipMeException, "UnzipMe needs a file.")
    expect {Unzipper.unzip(nil, mock_directory)}.to raise_error(UnzipMeException, "UnzipMe needs a file.")
  end


  private

  def mock_file
    mock(File)
  end

  def mock_directory
    mock(Dir)
  end


end
