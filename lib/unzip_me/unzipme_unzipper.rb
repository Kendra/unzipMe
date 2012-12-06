
class UnzipmeUnzipper

  def initialize(file, args={})
    validate_file(file)
    @args = args
    @file = file
  end

  def unzip
    run_system_unzip if @command == UnzipmeValidator::COMMAND_UNZIP
    run_system_7zip if @command == UnzipmeValidator::COMMAND_7ZIP
  end

  def file_list
    files = []

    listing_lines = IO.popen("unzip -l '#{@file}' 2>/dev/null") { |f| f.readlines } if @command == UnzipmeValidator::COMMAND_UNZIP
    listing_lines = IO.popen("7za l '#{@file}' 2>/dev/null") {|f| f.readlines} if @command == UnzipmeValidator::COMMAND_7ZIP

    listing_lines[0..-3].each_with_index do |line, idx| # The slice means ignore the last 3 lines of the list (just trailer information)
      next if idx < 3 # Skip the first three lines; just header information
      files << line.rstrip[27 + 1..-1] # The file name is the last column in the listing.
    end
    files
  end

  private

  def validate_file(file)
    zip_validator = UnzipmeValidator.new(file)
    raise(UnzipmeException, "#{zip_validator.error_message}") unless zip_validator.valid_zip?
    @command = zip_validator.command
  end

  def run_system_unzip
    if @args.has_key?(:extract_to)
      system("unzip -d \"#{@args[:extract_to]}\" \"#{@file}\" > /dev/null")
    else
      system("unzip \"#{@file}\" > /dev/null")
    end
    $?.exitstatus
  end

  def run_system_7zip
    if @args.has_key?(:extract_to)
      system("7za x \"#{@file}\" -o\"#{@args[:extract_to]}\" > /dev/null")
    else
      system("7za x \"#{@file}\" > /dev/null")
    end
    $?.exitstatus
  end

end
