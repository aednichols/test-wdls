version 1.0

workflow localizer_workflow {
  input {
    Int disk_size_gb = 500
    String disk_type_hdd_ssd = "SSD"
    Int vm_memory = 16
    Int vm_cpu = 4
    File input_file
  }
  
  call localizer_task {
    input:
      disk_size_gb = disk_size_gb,
      disk_type_hdd_ssd = disk_type_hdd_ssd,
      vm_memory = vm_memory,
      vm_cpu = vm_cpu,
      input_file = input_file
  }
  
  output {
    String o = localizer_task.out
  }
}

task localizer_task {
  input {
    Int disk_size_gb
    String disk_type_hdd_ssd
    Int vm_memory
    Int vm_cpu
    File input_file
  }
  
  command <<<
    pwd && ls -lah .
  >>>  
  
  runtime {
  	docker: "ubuntu:latest"
    disks: "local-disk " + disk_size_gb + " " + disk_type_hdd_ssd
    disk: disk_size_gb + " GB"
    cpu: vm_cpu
    memory: vm_memory + " GB"
  }

  meta {
    volatile: true
  }
  
  output {
    String out = read_string(stdout())
  }
}
