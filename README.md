
 
**To run App**
 
          $ git clone https://github.com/abdohsn/yalla-notlob-with-rails.git
          
          $ cd yalla-notlob-with-rails
          
          $ bundle install
    
          $ rails active_storage:install
    
          $ sudo yum install ImageMagick  (if centos) OR  $ sudo apt-get install ImageMagick (if ubuntu)
    
          $ rails db:migrate
    
          $ rails s 
    
  
 **Note you need to create your own database and connect to it** </br>
 at /config/database.yml do the following </br>
 username: your UserName </br>
 password: Your Password </br>
 database: Your db name (ex:otlob) </br>
