class Kong < Formula
  desc "Open source Microservices and API Gateway"
  homepage "https://docs.konghq.com"

  stable do
    url "https://bintray.com/kong/kong-src/download_file?file_path=kong-2.0.2.tar.gz"
    sha256 "0717663bc65849bc8f7b9efe93e48f9f5a6db849afafab8441bc7cc23e3c6c66"
    depends_on "issenn/kong/kong-openresty@1.15.8.2"
  end

  head do
    url "https://github.com/Kong/kong.git", :branch => "next"
    depends_on "issenn/kong/kong-openresty@1.15.8.2"
  end

  depends_on "libyaml"

  patch :DATA

  def install
    openresty_prefix = Formula["issenn/kong/kong-openresty@1.15.8.2"].prefix

    luarocks_prefix = openresty_prefix + "luarocks"
    openssl_prefix = openresty_prefix + "openssl"

    system "#{luarocks_prefix}/bin/luarocks",
           "--tree=#{prefix}",
           "make",
           "CRYPTO_DIR=#{openssl_prefix}",
           "OPENSSL_DIR=#{openssl_prefix}"

    bin.install "bin/kong"
  end
end

# patch Kong default `prefix` to `/usr/local/opt/kong` as `/usr/local/`
# not writable by non root user on OSX
__END__
diff --git a/kong/templates/kong_defaults.lua b/kong/templates/kong_defaults.lua
index e38b475..7a74a2f 100644
--- a/kong/templates/kong_defaults.lua
+++ b/kong/templates/kong_defaults.lua
@@ -1,5 +1,5 @@
 return [[
-prefix = /usr/local/kong/
+prefix = /usr/local/opt/kong/
 log_level = notice
 proxy_access_log = logs/access.log
 proxy_error_log = logs/error.log
