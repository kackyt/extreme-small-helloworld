#!/bin/ruby

require 'securerandom'

key = SecureRandom.random_number(0xFFFFFFFFFFFFFFFF)
file_size = 0
encode_count = 0
encoded_string = ""

open 'source.txt' do |f|
  inp = f.read
  file_size = inp.bytesize
  inp.force_encoding('ascii-8bit')
  padding = 0
  while (file_size + padding) % 8 != 0
    inp.concat(SecureRandom.random_number(255).chr)
    padding += 1
  end
  unp = inp.unpack("Q*")
  unp.each do |v|
    encoded = key ^ v
    encoded_string << "\t.quad 0x#{encoded.to_s(16)}\n"
  end
  encode_count = unp.length
end


puts <<"EOS"
	.section .text
	.global _start

_start:
	mov $0x#{key.to_s(16)}, %rax
	mov $2f, %esi
	mov $#{encode_count}, %cx
1:
	xor %rax, -8(%rsi, %rcx, 8)
	loop 1b
	mov $#{file_size}, %edx
	xor %rax, %rax
	inc %rax
	mov %rax, %rdi
	syscall
	xor %rax, %rax
	mov $60, %al
	xor %rdi, %rdi
	syscall
2:
#{encoded_string}
EOS

