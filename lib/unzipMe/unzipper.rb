
class Unzipper

  SUCCESS = 0

  def self.unzip(file, args={})

    raise(UnzipMeException, "UnzipMe needs a file.") unless file
    @args = args.merge!({:file => file})

    unzip_exitstatus = run_system_unzip

    if unzip_exitstatus != SUCCESS

      sevenzip_exitstatus = run_system_7zip

      if sevenzip_exitstatus != SUCCESS

        raise(UnzipMeException, "This is not a valid ZIP file. Exit Status Errors: \"unzip - #{UnzipMeError.unzip_error(unzip_exitstatus)}\" , \"7zip - #{UnzipMeError.seven_zip_error(sevenzip_exitstatus)}\"")

      end

    end


  end

  private

  def run_system_unzip

    if @args.has_key?(:extract_to)
      system("unzip -d \"#{@args[:extract_to]}\" \"#{@args[:file]}\" > /dev/null")
    else
      system("unzip \"#{@args[:file]}\" > /dev/null")
    end

    $?.exitstatus

  end

  def run_system_7zip

    if @args.has_key?(:extract_to)
      system("7za x \"#{@args[:file]}\" -o\"#{@args[:extract_to]}\" > /dev/null")
    else
      system("7za x \"#{@args[:file]}\" > /dev/null")
    end

    $?.exitstatus

  end



end