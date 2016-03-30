require 'spec_helper'

describe RecursiveUnzipper do
  let(:cut) { RecursiveUnzipper.new('/tmp/file/something.zip') }
  let(:dir) { '/tmp/recursive_unwrapper' }

  context '#extract_to' do

    it "will unzip the archive and recursively extract all zips" do
      m_unzipper = double('UnzipmeUnzipper')
      m_unzipper.should_receive(:unzip)

      cut.should_receive(:scan_and_unzip_dir).with('/tmp/somewhere')

      UnzipmeUnzipper.should_receive(:new).with('/tmp/file/something.zip', { extract_to: '/tmp/somewhere' }).and_return(m_unzipper)

      cut.extract_to('/tmp/somewhere')
    end

  end

  context '#unzip_all_zips_in_directory' do

    it 'should do nothing if no zip found in the specified directory' do
      FileUtils.mkdir_p(dir)

      begin
        cut.send(:unzip_all_zips_in_directory, dir)
      ensure
        FileUtils.rm_rf(dir)
      end

    end

    it "should unpack the zip if found in directory" do
      FileUtils.mkdir_p(dir)

      %x{ touch #{File.join(dir, "something.zip") } }

      m_unzipper = double('UnzipmeUnzipper')
      m_unzipper.should_receive(:unzip)
      zip_path = File.join(dir, 'something.zip')
      UnzipmeUnzipper.should_receive(:new).with(zip_path, { extract_to: '/tmp/recursive_unwrapper/something.zip.contents' }).and_return(m_unzipper)

      begin
        cut.send(:unzip_all_zips_in_directory, dir)

        # The contents directory should be created
        contents_dir = File.join(dir, 'something.zip.contents')
        expect(File.exists?(contents_dir)).to be_true
        expect(File.directory?(contents_dir)).to be_true

        # The zip file should be deleted
        expect(File.exists?(zip_path)).to be_false
      ensure
        FileUtils.rm_rf(dir)
      end

    end

    it "should catch exception, record and remove the zip file" do
      FileUtils.mkdir_p(dir)

      %x{ touch #{File.join(dir, "something.zip") } }

      m_unzipper = double('UnzipmeUnzipper')
      m_unzipper.should_receive(:unzip).and_raise(StandardError)
      zip_path = File.join(dir, 'something.zip')
      UnzipmeUnzipper.should_receive(:new).with(zip_path, { extract_to: '/tmp/recursive_unwrapper/something.zip.contents' }).and_return(m_unzipper)

      begin
        cut.send(:unzip_all_zips_in_directory, dir)

        # The contents directory should be removed
        contents_dir = File.join(dir, 'something.zip.contents')
        expect(File.exists?(contents_dir)).to be_false

        # The zip file should be deleted
        expect(File.exists?(zip_path)).to be_false
        expect(cut.exceptions.count).to be(1)
      ensure
        FileUtils.rm_rf(dir)
      end

    end
  end

  context '#scan_and_unzip_dir' do

    it "should just unzip all zip in dir if no other files in directory" do
      FileUtils.mkdir_p(dir)
      
      cut.should_receive(:unzip_all_zips_in_directory).with(dir)

      cut.send(:scan_and_unzip_dir, dir)
    end

  end

end
