version 1.0

# 16 vCPUs gets us into the highest 1200 MB/s disk bandwidth bucket [0]
# A 2.5 TB disk is the smallest to max out that 1200 MB/s [1]
# [0] https://cloud.google.com/compute/docs/disks/performance#throughput_limits_for_zonal
# [1] https://cloud.google.com/compute/docs/disks/performance#n1_vms
# https://cloud.google.com/compute/docs/network-bandwidth#vm-out-baseline
workflow localizer_workflow {
  input {
    Int disk_size_gb = 2500
    String disk_type_hdd_ssd = "SSD"
    Int vm_memory = 32
    Int vm_cpu = 16
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
    String stdout = localizer_task.stdout
    File output_file = localizer_task.output_file
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
    docker: "rockylinux:9"
    disks: "local-disk " + disk_size_gb + " " + disk_type_hdd_ssd
    disk: disk_size_gb + " GB"
    cpu: vm_cpu
    memory: vm_memory + " GB"
    cpuPlatform: "Intel Ice Lake"
  }

  meta {
    volatile: true
  }
  
  output {
    String stdout = read_string(stdout())
    File output_file = sub(input_file, 'gs://', '')
  }
}
