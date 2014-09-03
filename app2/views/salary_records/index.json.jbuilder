json.array!(@salary_records) do |salary_record|
  json.extract! salary_record, :id, :employee_id, :month, :salary, :distribution, :net_salary, :comments
  json.url salary_record_url(salary_record, format: :json)
end
