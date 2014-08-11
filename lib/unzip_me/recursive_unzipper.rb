class RecursiveUnzipper
  attr_reader :zip_path, :exceptions

  def initialize(zip_path)
    @zip_path = zip_path
    @exceptions = {}
  end

  def extract_to(extract_to_path)
    UnzipmeUnzipper.new(zip_path, { extract_to: extract_to_path }).unzip
    scan_and_unzip_dir(extract_to_path)
  end

  private

  def scan_and_unzip_dir(dir)
    unzip_all_zips_in_directory(dir)

    # Are there any sub-directories in this directory?
    Dir.foreach(dir) do |entry|
      next if [ '.', '..' ].include?(entry)
      path = File.join(dir, entry)
      scan_and_unzip_dir(path) if File.directory?(path)
    end
  end

  def unzip_all_zips_in_directory(dir)
    # Are there any zip files in this directory? If so,
    # extract the contents to a subdirectory of the 
    # current directory
    Dir.glob(File.join(dir, "*.zip"), File::FNM_CASEFOLD) do | zip_file_name |
      # Create a directory in which to place the contents of the zip
      contents_dir = File.join(dir, "#{File.basename(zip_file_name)}.contents")
      FileUtils.mkdir_p(contents_dir)
      begin
        UnzipmeUnzipper.new(zip_file_name, { extract_to: contents_dir }).unzip
      rescue => ex
        FileUtils.rm_rf(contents_dir)
        exceptions[zip_file_name] = ex
      ensure
        File.delete(zip_file_name)
      end
    end
  end

end

