function exists_file() {
    local file_path="$1"
    if [ ! -f "$file_path" ]; then
        error "ファイルが見つかりません: $file_path"
    fi
}
