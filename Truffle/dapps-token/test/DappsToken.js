var DappsToken = artifacts.require("./DappsToken.sol");

contract('DappsToken', function(accounts) {

  // 테스트 내용을 설명함 "첫번째 계정이 1000DappsToken을 저장했는지 여부"를 테스트합니다
  // DappsToken 배포후 instance를 함수 파라미터로 설정해 전달합니다
  // 그리고, instance 변수에 계정 0의 토큰 발행 수를 리턴합니다.

  it("should put 1000 DappsToken in the first account", function() {
    return DappsToken.deployed().then(function(instance) {
      return instance.balanceOf.call(accounts[0]);

  // balance를 함수의 파라미터로 설정해 전달한 후 .valueOf()를 이용해 balance 변수값이 1000과 같은지 확인한다.
  // tip > 테스트를 실행하기 전 contracts 디렉토리의 Migrations.sol 파일 안 Migrations 함수 이름을 계약 이름과 같지 않게 수정해야 합니다.
    }).then(function(balance) {
        assert.equal(balance.valueOf(), 1000, "1000 wasn't in the first account");
    });
  });
});
