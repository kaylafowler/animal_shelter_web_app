require_relative('../db/sql_runner.rb')

class Customer

  attr_reader(:id, :first_name, :last_name, :phone, :email, :address_line_1, :address_line_2, :address_city, :address_post_code )

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @first_name = options['first_name']
    @last_name = options['last_name']
    @phone = options['phone']
    @email = options['email']
    @address_line_1 = options['address_line_1']
    @address_line_2 = options['address_line_2']
    @address_city = options['address_city']
    @address_post_code = options['address_post_code']
  end

  def save()
    sql = "INSERT INTO customers
    (
      first_name,
      last_name,
      phone,
      email,
      address_line_1,
      address_line_2,
      address_city,
      address_post_code
    )
    VALUES
    (
      $1, $2, $3, $4, $5, $6, $7, $8
    )
    RETURNING id"
    values = [@first_name, @last_name, @phone, @email, @address_line_1, @address_line_2, @address_city, @address_post_code]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i()
  end

  def self.all()
    sql = "SELECT * FROM customers"
    values = []
    results = SqlRunner.run(sql, values)
    return results.map{|customer| Customer.new(customer)}
  end

  def self.find(id)
    sql = "SELECT * FROM customers
    WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    return Customer.new(results[0])
  end

  def update()
    sql = "UPDATE customers
    SET
    (
      first_name,
      last_name,
      phone,
      email,
      address_line_1,
      address_line_2,
      address_city,
      address_post_code
    ) =
    (
      $1, $2, $3, $4, $5, $6, $7, $8
    )
    WHERE id = $9"
    values = [@first_name, @last_name, @phone, @email, @address_line_1, @address_line_2, @address_city, @address_post_code, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end


  def animals()
    sql = "SELECT animals.*
    FROM animals
    INNER JOIN adoptions
    ON adoptions.animal_id = animals.id
    WHERE adoptions.customer_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map{|result| Animal.new(result)}
  end
end
