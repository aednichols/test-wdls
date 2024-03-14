version 1.0

workflow minimal_hello_world {
  input {
    String image = "rockylinux:9"
  }

  call hello_world {
    input:
      image = image
  }

  output {	
    String stdout = hello_world.stdout
  }
}

task hello_world {

  input {
    String image
  }

  command <<<
  	cat /etc/os-release
    uname -a
    cat /proc/cpuinfo
  >>>

  runtime {
    docker: image
  }

  meta {
    volatile: true
  }

  output {
    String stdout = read_string(stdout())
  }
}