pragma solidity ^0.4.0;

//创建众筹事件=>捐赠=>提款

//众筹合约
contract crowdfunding{

    //捐赠者对象
    struct funder{

        address funderaddress;  //捐赠者地址

        uint Tomoney;  //捐赠者捐赠金额

    }

    //受益人对象
	struct needer{

		address Neederaddress;  //受益人地址
        
        uint goal;  //受益人目标值
        
        uint amount;  //收益人当前已募集的金额
        
        uint funderAccount;  //捐赠者id
        
        mapping(uint => funder) map;  //映射，将捐赠者id与捐赠者绑定

	}

    uint neederAmount;  //收益人的id数

    mapping(uint => needer) needmap;  //映射，将受益人id与受益人绑定

    //实现众筹事件
	function NewNeeder(address _Neederaddress, uint _goal){

    	neederAmount++;  //将受益人id与受益人绑定
		
		needmap[neederAmount] = needer(_Neederaddress,_goal,0,0);

	}

	//@param _address 捐赠者地址，
	//@param _neederAmount 受益人id
    function contribute(address _address, uint _neederAmount) payable{
   
    	needer storage _needer = needmap[_neederAmount];  //通过id获取受益人对象
        
    	_needer.amount += msg.value;  //募集到的资金增加
        
    	_needer.funderAccount++;  //捐赠人数增加
        
    	_needer.map[_needer.funderAccount] = funder(_address, msg.value);  //将受益人id与受益人绑定

    }

    //当募集到的资金满足条件，就会给受益人的地址转账
    //@param _neederAmount 受益人的id
    function IScompelete(uint _neederAmount){
    	
    	needer storage _needer = needmap[_neederAmount];
        
        if(_needer.amount >= _needer.goal){

    	    _needer.Neederaddress.transfer(_needer.amount);

        }

    }

    function test() view returns(uint, uint, uint){

    	return (needmap[1].goal, needmap[1].amount, needmap[1].funderAccount)

    }
    
}