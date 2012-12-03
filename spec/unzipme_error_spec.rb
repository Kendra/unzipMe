require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UnzipmeError do

  it "provides the error message based on the $? exit code " do
    UnzipmeError.unzip_error(1).should == "one or more warning errors were encountered."
  end

end