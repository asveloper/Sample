json.array!(@salary_increments) do |salary_increment|
  json.extract! salary_increment, :id, :employee_id, :date, :amount, :incremented_salary, :comments
  json.url salary_increment_url(salary_increment, format: :json)
end
