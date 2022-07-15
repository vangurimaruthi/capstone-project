pragma solidity ^0.5.16;

contract DecentralizedUniversity {
    
address universityAdmin;
uint256 public totalNoOfColleges;
uint256 public totalNoOfStudents;

constructor() public {
   universityAdmin = msg.sender; 
}
modifier onlyAdmin(){
   require(msg.sender == universityAdmin);
   _;}
   
struct College{
   string cName;  
   address cAddress;
   address cAdmin;
   string cRegNo;
   bool isAllowedToAddStudents;
   uint totalNoOfStudents;
} 

struct Student{
   string sName;  
   uint phoneNo;
   string courseEnrolled;
} 

mapping (address => College) colleges; //  Mapping a college's address to college
mapping (string => Student) students; //  Mapping a student's name to student


    /********************************************************************************************************************
     *
     *  Name        :   addNewCollege
     *  Description :   This function is used by the University admin to add a new college. This function can be called by admin only.
     *  Parameters  :
     *      param  {string} collegeName :  The name of the college.
     *      param  {address} add :  The  unique Ethereum address of the college
     *      param  {string} regNo :  College registration Number
     *
     *******************************************************************************************************************/

function addNewCollege(string memory collegeName, address add, address cAdmin, string memory regNo) public onlyAdmin {
   require(!areBothStringSame(colleges[add].cName,collegeName), "College already exists with same name");
   colleges[add]= College(collegeName,add,cAdmin,regNo,true,0);
   totalNoOfColleges++;
}

    /********************************************************************************************************************
     *
     *  Name        :   viewCollegeDetails
     *  Description :   This function is used to view college details.
     *  Parameters  :
     *      param  {address} add :  The  unique Ethereum address of the college.
     *
     *******************************************************************************************************************/
     
function viewCollegeDetails(address add) public view returns (string memory, string memory, uint) {
   return (colleges[add].cName,colleges[add].cRegNo, colleges[add].totalNoOfStudents);
}

    /********************************************************************************************************************
     *
     *  Name        :   blockCollegeToAddNewStudents
     *  Description :   This function is used by the University admin to block college to add any new student.
     *  Parameters  :
     *      param  {address} add :  The  unique Ethereum address of the college
     *
     *******************************************************************************************************************/

function blockCollegeToAddNewStudents(address add) public onlyAdmin {
   require(colleges[add].isAllowedToAddStudents, "College is already blocked to add new students");
   colleges[add].isAllowedToAddStudents=false;
}


    /********************************************************************************************************************
     *
     *  Name        :   unblockCollegeToAddNewStudents
     *  Description :   This function is used by the University admin to unblock college to add any new student.
     *  Parameters  :
     *      param  {address} add :  The  unique Ethereum address of the college
     *
     *******************************************************************************************************************/

function unblockCollegeToAddNewStudents(address add) public onlyAdmin {
   require(!colleges[add].isAllowedToAddStudents, "College is already unblocked to add new students");
   colleges[add].isAllowedToAddStudents=true;
}
    /********************************************************************************************************************
     *
     *  Name        :   addNewStudentToCollege
     *  Description :   This function will add a customer to the customer list. If IsAllowed is false then don't process
     *                  the request.
     *  Parameters  :
     *      param  {address} add :  The  unique address of the college
     *      param {string} sName :  The name of the student.
     *      param {uint} phoneNo :  The phone number of the student.
     *      param {string} courseName :  The name of the course.
     *******************************************************************************************************************/
    function addNewStudentToCollege(address add,string memory sName, uint phoneNo, string memory courseName ) public {
        require(colleges[add].isAllowedToAddStudents, "This College is blocked to add new students");
        require(colleges[add].cAdmin == msg.sender, "Only College admin can add the new student");
        students[sName] = Student(sName,phoneNo,courseName);
        colleges[add].totalNoOfStudents += 1;
        totalNoOfStudents++;
    }

    /********************************************************************************************************************
     *
     *  Name        :   getNumberOfStudentForCollege
     *  Description :   This function will return the number of students enrolled in given college.
     *  Parameters  :
     *       param  {address} add :  The  unique address of the college
     *
     *******************************************************************************************************************/
    function getNumberOfStudentForCollege(address add) public view returns(uint){
        return (colleges[add].totalNoOfStudents);
    }
    
        /********************************************************************************************************************
     *
     *  Name        :   viewStudentDetails
     *  Description :   This function is used to view student details.
     *  Parameters  :
     *      param  {string} sName :  The  name of the student.
     *
     *******************************************************************************************************************/
     
function viewStudentDetails(string memory sName) public view returns (string memory, uint, string memory) {
   return (students[sName].sName,students[sName].phoneNo, students[sName].courseEnrolled);
}

    /********************************************************************************************************************
     *
     *  Name        :   changeStudentCourse
     *  Description :   This function is used by College admin to change student course.
     *  Parameters  :
     *      param  {address} add :  TThe  unique address of the college.
     *      param  {string} sName :  The  name of the student.
     *      param  {string} newCourse :  The  new course name.
     *
     *******************************************************************************************************************/
     
function changeStudentCourse(address add, string memory sName, string memory newCourse) public {
       require(!areBothStringSame(students[sName].courseEnrolled,newCourse), "Student already enrolled to same course");
       require(colleges[add].cAdmin == msg.sender, "Only College admin can change the student course");
       students[sName].courseEnrolled=newCourse;
}


   /********************************************************************************************************************
     *
     *  Name        :   areBothStringSame
     *  Description :   This is an internal function is verify equality of strings
     *  Parameters  :
     *      @param {string} a :   1st string
     *      @param  {string} b :   2nd string
     *
     *******************************************************************************************************************/

    function areBothStringSame(string memory a, string memory b) private pure returns (bool) {
        if(bytes(a).length != bytes(b).length) {
            return false;
        } else {
            return keccak256(bytes(a)) == keccak256(bytes(b));
        }
    }

}
