require 'aws-sdk'

module S3Actions
  @region = 'us-east-1'

  def self.s3_upload(s3_bucket, s3_path, file)
    s3 = Aws::S3::Client.new(region: @region)
    unless file.class == File
      STDERR.puts("Expecting class = File, got: #{file.class}")
      return 1
    end
    resp = s3.put_object(
      bucket: s3_bucket,
      key: "#{s3_path}/#{File.basename(file)}",
      body: file
    )
    unless resp.successful?
      STDERR.puts("Error: #{resp.data}")
      return 1
    end
    return 0
  end

  def self.s3_download(s3_bucket, key, target_file)
    s3 = Aws::S3::Client.new(region: @region)
    resp = s3.get_object(
      bucket: s3_bucket,
      key: key,
      response_target: target_file
    )
    unless resp.successful?
      STDERR.puts('File download error')
      STDERR.puts(resp.data)
      return 1
    end
  end
end
