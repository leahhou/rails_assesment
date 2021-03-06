describe('Rails Log In/Log Out', function() {
    before(function() {
        cy.app("clean")
        cy.app("seed")
       
    });
    it("Login works with correct username and password", function() {
        
        cy.visit("/users/sign_in"); // go to sign up page correctly
        
        
        cy.get("[name='user[email]']").type("alex@test.com"); // select username field and type in leah
        
        cy.get("[name='user[password]']").type("alex1234"); // select password field and type in password

        cy.get("[name='commit']").click(); //click "sign up" button to sumbit registration form
        
        cy.contains("Signed in successfully."); //automatically redirect to home and show successfully log in
    });
    
   
    it("Logout", function(){
        cy.contains("Log Out").click();
        cy.contains("Signed out successfully.");
    });

    it("Login fails with wrong password", function() {
        
        cy.visit("/users/sign_in"); 
        cy.get("[name='user[email]']").type("alex@test.com"); 
        
        cy.get("[name='user[password]']").type("alex123456"); 

        cy.get("[name='commit']").click(); 
        
        cy.contains("Invalid Email or password."); 
    });

    it("Login fails with wrong email", function() {
        
        cy.visit("/users/sign_in"); 
        cy.get("[name='user[email]']").type("garret@test.com"); 
        
        cy.get("[name='user[password]']").type("alex123456"); 

        cy.get("[name='commit']").click(); 
        
        cy.contains("Invalid Email or password."); 
    });
    
});