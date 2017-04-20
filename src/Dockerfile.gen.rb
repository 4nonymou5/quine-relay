require_relative "code-gen"

apts = RunSteps.flat_map {|s| s.apt }
other_packages = %w(cmake libpng-dev libgd-dev groff)

apts = [*apts.flatten.compact.uniq, *other_packages].sort

dockerfile = []
dockerfile << "FROM ubuntu:17.04"
dockerfile << "RUN apt-get -qq update > /dev/null"
dockerfile << "RUN apt-get -qq upgrade -y > /dev/null"
dockerfile << "RUN apt-get -qq install -y apt-utils > /dev/null"
apts.each do |apt|
  dockerfile << "RUN apt-get -qq install -y #{ apt } > /dev/null"
end
dockerfile << "ENV PATH /usr/games:$PATH"
dockerfile << "ADD . /usr/local/share/quine-relay"
dockerfile << "WORKDIR /usr/local/share/quine-relay"
dockerfile << "RUN make -C vendor"
dockerfile << "CMD make check -j 10000"

File.write("../Dockerfile", dockerfile.join("\n") + "\n")
