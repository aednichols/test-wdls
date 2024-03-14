version 1.0

workflow machine_exerciser {
  input {
    Int disk_size_gb = 500
    String disk_type_hdd_ssd = "SSD"
    Int vm_memory = 32
    Int vm_cpu = 8
    String dns_lookup = "broadinstitute.org"
    String image = "rockylinux:9"
  }

  call noop_task {
    input:
      disk_size_gb = disk_size_gb,
      disk_type_hdd_ssd = disk_type_hdd_ssd,
      vm_memory = vm_memory,
      vm_cpu = vm_cpu,
      dns_lookup = dns_lookup,
      image = image
  }

  output {
    String o = noop_task.out
  }
}

task noop_task {
  input {
    Int disk_size_gb
    String disk_type_hdd_ssd
    Int vm_memory
    Int vm_cpu
    String dns_lookup
    String image
  }

  command <<<
    dnf -y install bind-utils
    dig ~{dns_lookup}
  >>>  

  runtime {
    docker: image
    disks: "local-disk " + disk_size_gb + " " + disk_type_hdd_ssd
    disk: disk_size_gb + " GB"
    cpu: vm_cpu
    memory: vm_memory + " GB"
  }

  output {
    String out = read_string(stdout())
  }

  meta {
    volatile: true
  }
}
