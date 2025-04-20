#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'

# Usage: ruby generate_markdown.rb <input_directory> <output_directory>
# <input_directory>: 画像が保存されているディレクトリ（PNG, SVG）
# <output_directory>: 出力先ディレクトリ（存在しない場合、エラー）

# 引数でディレクトリを指定、指定がなければカレントディレクトリの 'png' を使用
input_dir = ARGV[0] || File.join(__dir__, 'png')
output_dir = ARGV[1] || ARGV[0]

# 出力先ディレクトリが存在するか確認
unless Dir.exist?(output_dir)
  puts "エラー: 出力先ディレクトリ '#{output_dir}' が存在しません。"
  puts "Usage: ruby generate_markdown.rb <input_directory> <output_directory>"
  exit 1
end

# 出力先のMarkdownファイル名
output_file = File.join(output_dir, 'README.md')

# 出力用のMarkdownヘッダー
header = <<~HEADER
  # Image Files

  以下は、プロジェクト内の画像ファイルです。

HEADER

# 出力先ファイルを開く（上書きモード）
File.open(output_file, 'w') do |file|
  file.puts(header)

  # ディレクトリ内のPNGファイルを、ファイル名の数字部分を基準にソート
  sorted_files = Dir.glob(File.join(input_dir, '*.png')).sort_by do |file|
    # ファイル名から数字を抽出（例: pose-1.png から 1 を抽出）
    file.match(/(\d+)/) ? $1.to_i : 0
  end

  sorted_files.each do |image_path|
    image_name = File.basename(image_path)
    file.puts("## #{image_name}")
    file.puts("![#{image_name}](#{File.join(input_dir, image_name)})")
    file.puts
  end
end

puts "Markdownファイル '#{output_file}' が作成されました。"

