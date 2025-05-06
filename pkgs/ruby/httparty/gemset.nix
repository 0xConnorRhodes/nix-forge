{
  bigdecimal = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k6qzammv9r6b2cw3siasaik18i6wjc5m0gw5nfdc6jj64h79z1g";
      type = "gem";
    };
    version = "3.1.9";
  };
  csv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kfqg0m6vqs6c67296f10cr07im5mffj90k2b5dsm51liidcsvp9";
      type = "gem";
    };
    version = "3.3.4";
  };
  httparty = {
    dependencies = ["csv" "mini_mime" "multi_xml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mbbjr774zxb2wcpbwc93l0i481bxk7ga5hpap76w3q1y9idvh9s";
      type = "gem";
    };
    version = "0.23.1";
  };
  mini_mime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vycif7pjzkr29mfk4dlqv3disc5dn0va04lkwajlpr1wkibg0c6";
      type = "gem";
    };
    version = "1.1.5";
  };
  multi_xml = {
    dependencies = ["bigdecimal"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kl7ax7zcj8czlxs6vn3kdhpnz1dwva4y5zwnavssfv193f9cyih";
      type = "gem";
    };
    version = "0.7.2";
  };
}
