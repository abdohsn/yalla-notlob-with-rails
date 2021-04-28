
 
**To run App </br> Note #1:**</br>

we use Ruby with version 3.0.0p0 </br>
and Rails version 6.1.3.1 </br>
 
          $ git clone https://github.com/abdohsn/yalla-notlob-with-rails.git
          
          $ cd yalla-notlob-with-rails
          
          $ bundle install
    
          $ rails active_storage:install
    
          $ sudo yum install ImageMagick  (if centos) OR  $ sudo apt-get install ImageMagick (if ubuntu)
    
          $ rails db:migrate
    
          $ rails s 
    
  
 **Note #2:</br> you need to create your own database and connect to it** </br>
 at /config/database.yml do the following </br>
 username: Your UserName </br>
 password: Your Password </br>
 database: Your db name (ex:otlob) </br>
