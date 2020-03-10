# Docker MS SQL Server Operations 
---

This is a showcase of **[Thorntail](https://thorntail.io)**, formerly knowns as **Wildfly Swarm**. The same way we can quickly get going with **Spring Boot** to build web apps, there' something similar to it for those who want to rather use more of **Java / Jakarta EE**. This code base is reference for the **[Java EE Micro Services Using Thorntail](https://informingtechies.blogspot.com/2020/03/micro-services-using-thorntail.html)** article.


## Technology Stack Used

1. Java 8
2. Maven 3.6.2
3. IntelliJ IDEA *(You may use an IDE of your choice)*


## Setting Up

```bash
# After checking out run:
mvn clean install
```

```bash
# To run the Service type:
java -jar target/thorntail-api-thorntail.jar
```


## Testing                     

- Access the link [http://localhost:8881/swagger-ui](http://localhost:8881/swagger-ui)
- Insert the url *http://localhost:8881/that-service/swagger.json* in the text box. 


And there you go, should be all set. 
