# script/check_structure.rb

def check_file(path)
  unless File.exist?(path)
    puts "❌ Arquivo não encontrado: #{path}"
    return false
  end
  puts "✅ Encontrado: #{path}"
  true
end

def check_content(path, expected)
  content = File.read(path)
  unless content.include?(expected)
    puts "❌ Conteúdo esperado NÃO encontrado em #{path}"
    puts "   Esperado: #{expected}"
    return false
  end
  puts "✅ Conteúdo OK em #{path}"
  true
end

puts "🔍 Verificando estrutura do projeto Hanami...\n\n"

errors = 0


if check_file("app/action.rb")
  errors += 1 unless check_content("app/action.rb", "module DataAnalyzerApi")
  errors += 1 unless check_content("app/action.rb", "class Action")
else
  errors += 1
end


if check_file("slices/api/action.rb")
  errors += 1 unless check_content("slices/api/action.rb", "module Api")
  errors += 1 unless check_content("slices/api/action.rb", "class Action")
else
  errors += 1
end


errors += 1 unless check_file("slices/api/actions/uploads/create.rb")

puts
if errors.zero?
  puts "🎉 Estrutura OK! Nenhum problema encontrado."
else
  puts "⚠️ Foram encontrados #{errors} problema(s)."
end

exit(errors.zero? ? 0 : 1)
