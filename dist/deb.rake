file pkg("/kidsruby-#{version}.deb") => distribution_files("deb") do |t|
  mkchdir(File.dirname(t.name)) do
    mkchdir("usr/local/kidsruby") do
      assemble_distribution
      assemble_gems
      assemble resource("deb/kidsruby"), "bin/kidsruby", 0755
    end

    assemble resource("deb/control"), "control"
    assemble resource("deb/postinst"), "postinst"

    sh "tar czvf data.tar.gz usr/local/kidsruby --owner=root --group=root"
    sh "tar czvf control.tar.gz control postinst"

    File.open("debian-binary", "w") do |f|
      f.puts "2.0"
    end

    deb = File.basename(t.name)

    sh "ar -r #{t.name} debian-binary control.tar.gz data.tar.gz"
  end
end

desc "Build a .deb package"
task "deb:build" => pkg("/kidsruby-#{version}.deb")

desc "Remove build artifacts for .deb"
task "deb:clean" do
  clean pkg("kidsruby-#{version}.deb")
  FileUtils.rm_rf("pkg/kidsruby-#{version}") if Dir.exists?("pkg/kidsruby-#{version}")
end