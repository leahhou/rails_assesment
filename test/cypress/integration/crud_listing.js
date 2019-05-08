describe('Rails Listing CRUD', function() {

    beforeEach(function() {
        cy.login()
    })

    it("create a listing", function() {
        
           cy.contains("create a new listing").click(); //click "create a new listing" button to go to new listing page
    
           cy.get("[name='listing[artist]']").type("Radiohead"); // type in "Al Green" into artist
        
           cy.get("[name='listing[title]']").type("Pablo Honey "); // type in "Pablo Honest" into artist

           cy.get('select').select('2LP').should('have.value', '1'); // select "2LP" from format dropdown menu

           cy.get("[name='listing[year]']").type("1993"); // type in "1993" into year

           cy.get("[name='listing[price]']").type("200"); // type in "1993" into year

           cy.get("[type='radio']").check("good"); // choose "wore" in condition

           cy.get("[name='listing[description]']").type("Pick Up Only"); // type in "Pick Up Only" into description.

           cy.contains("Create Listing").click(); // click "create listing" button to submit 1st part of the form

           cy.get("[type='checkbox']").check(['4', '2']); // choose "wore" in condition

           cy.contains("Update Listing").click(); // click "update listing" button to submit 2nd part of the form

    });

    it("update a listing", function() {
        
        cy.visit("/"); 

        cy.contains("go to album").click()

        cy.contains("edit album").click(); 

        cy.get("[name='listing[artist]']").type("The Beatles"); 
     
        cy.get("[name='listing[title]']").type("Hey Jude"); 
        cy.get('select').select('2LP').should('have.value', '1'); 

        cy.get("[name='listing[year]']").type("1993"); 

        cy.get("[type='radio']").check("good"); 

        cy.get("[name='listing[description]']").type("Pick Up Only"); 

        cy.contains("Update Listing").click(); // click "create listing" button to submit 1st part of the form

        cy.get("[type='checkbox']").check(['4', '2']); // choose "wore" in condition

        cy.contains("Update Listing").click(); // click "update listing" button to submit 2nd part of the 

    });

    it("delete a listing", function() {
        cy.visit("/"); 

        cy.contains("go to album").click()

        cy.contains("delete album").click(); 

    });
});