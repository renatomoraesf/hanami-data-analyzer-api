app = ->(env) do
  [200, {"Content-Type" => "text/plain"}, ["Teste Rack OK"]]
end
run app
