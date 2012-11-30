module UnzipMeError

  def self.unzip_error(exit_code)
    case exit_code
      when 1 then "one or more warning errors were encountered"
      when 2 then "a generic error in the zipfile format was detected."
      when 3 then "a severe error in the zipfile format was detected."
      when 4 then "unzip was unable to allocate memory for one or more buffers during program initialization."
      when 5 then "unzip was unable to allocate memory or unable to obtain a tty to read the decryption password(s)."
      when 6 then "unzip was unable to allocate memory during decompression to disk."
      when 7 then "unzip was unable to allocate memory during in-memory decompression."
      when 9 then "the specified zipfiles were not found."
      when 10 then "invalid options were specified on the command line."
      when 11 then "no matching files were found."
      when 50 then "the disk is (or was) full during extraction"
      when 51 then "the end of the ZIP archive was encountered prematurely."
      when 80 then "the user aborted unzip prematurely with control-C (or similar)"
      when 81 then "testing or extraction of one or more files failed due to unsupported compression methods or unsupported decryption."
      when 82 then "no files were found due to bad decryption password(s)."
      else ""
    end
  end


  def self.seven_zip_error(exit_code)
    case exit_code
      when 1 then "Warning (Non fatal error(s))."
      when 2 then "Fatal error."
      when 7 then "Command line error."
      when 8 then "Not enough memory for operation."
      when 255 then "User stopped the process."
      else ""
    end
  end

end