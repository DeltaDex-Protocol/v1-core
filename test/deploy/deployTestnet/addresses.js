const LoadAddresses = () => {
  var fs = require("fs");
  // fs.writeFile('../deploy/deployTestnet/myjsonfile.json', `{"table": []}`, 'utf8', () => {});
  return JSON.parse(fs.readFileSync("test/deploy/deployTestnet/addresses.json", "utf8"));
};

// [{name: '', addr: ''}]
const UpdateAddresses = (newAddresses) => {
  var fs = require("fs");

  newAddresses = JSON.stringify(newAddresses);
  fs.writeFileSync("./addresses.json", newAddresses, "utf8");
};

module.exports = { LoadAddresses, UpdateAddresses };
