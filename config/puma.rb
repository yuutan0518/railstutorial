# workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/
  # deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end

# SSL通信用設定追加（認証ファイルが存在しなかったら作成する）
if Rails.env.development?
  key_file = Rails.root.join("config", "certs", "localhost.key")
  cert_file = Rails.root.join("config", "certs", "localhost.cert")

  unless key_file.exist?
    root_key = OpenSSL::PKey::RSA.new(2048)
    key_file.write(root_key)

    root_cert = OpenSSL::X509::Certificate.new.tap do |root_ca|
      root_ca.version = 2 # cf. RFC 5280 - to make it a "v3" certificate
      root_ca.serial = 0x0
      root_ca.subject = OpenSSL::X509::Name.parse "/C=BE/O=A1/OU=A/CN=localhost"
      root_ca.issuer = root_ca.subject # root CA"s are "self-signed"
      root_ca.public_key = root_key.public_key
      root_ca.not_before = Time.now
      root_ca.not_after = root_ca.not_before + 2 * 365 * 24 * 60 * 60 # 2 years validity
      root_ca.sign(root_key, OpenSSL::Digest::SHA256.new)
    end
    cert_file.write(root_cert)
  end

  ssl_bind "0.0.0.0", "8443", {
    key: key_file.to_path,
    cert: cert_file.to_path
  }
end