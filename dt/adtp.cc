#include <array>
#include <cstdint>
#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>
#include <iostream>
#include <unordered_map>

#define PACKED __attribute__((packed))

class ADTStream {
public:
  void *data;
  void *end;

  ADTStream(void *data, void *end)
    : data(data), end(end) {}

  bool eof() {
    return data == end;
  }

  template<class T>
  T read()
  {
    typeof(((T*)nullptr)->raw()) * tp = (typeof(((T*)nullptr)->raw())*)data;
    data = (void *)(tp+1);
    if (data > end)
      abort();

    return T(*tp, *this);
  }
};

class uint24_t {
public:
  uint8_t data[3];

  operator size_t() {
    return data[0] + (data[1] << 8) + (data[2] << 16);
  }
} PACKED;

static void dump_escaped_char(uint8_t ch)
{
  if (ch >= 0x20 && ch < 0x7f)
    printf("%c", ch);
  else
    printf("\\x%02x", ch);
}

class uint8_le_t {
public:
  uint8_t data[1];

  operator size_t() {
    return data[0];
  }

  static const bool do_dump_as_string = false;

  void dump_as_js()
  {
    printf("%02lx", (unsigned long)size_t(*this) & 0xff);
  }

  void dump_as_js_comment()
  {
    printf("/* ");
    for (auto ch : data)
      dump_escaped_char(ch);
    printf(" */");
  }

  void dump_as_js_string()
  {
    printf("\"");
    for (auto ch : data)
      dump_escaped_char(ch);
    printf("\"");
  }
} PACKED;

class uint32_le_t {
public:
  uint8_t data[4];

  operator size_t() {
    return data[0] + (data[1] << 8) + (data[2] << 16) + (data[3] << 24);
  }

  static const bool do_dump_as_string = false;

  void dump_as_js()
  {
    printf("0x%08lx", (unsigned long)size_t(*this) & 0xffffffff);
  }

  void dump_as_js_comment()
  {
    printf("/* ");
    for (auto ch : data)
      dump_escaped_char(ch);
    printf(" */");
  }

  void dump_as_js_string()
  {
    printf("\"");
    for (auto ch : data)
      dump_escaped_char(ch);
    printf("\"");
  }
} PACKED;

template<class T>
class ADTRaw {
public:
  T data;
  T raw()
  {
    return data;
  }

  ADTRaw(T data, ADTStream &) : data(data) {}
  ADTRaw(T data) : data(data) {}

  T val()
  {
    return data;
  }

  operator T()
  {
    return val();
  }
};

template<size_t n>
class ADTString : public ADTRaw<std::array<char,n>> {
public:
  std::string val()
  {
    std::string ret(this->ADTRaw<std::array<char,n>>::val().data(), n);
    for (size_t i = 0; i < n; i++)
      if (ret[i] == 0)
	return std::string(ret, 0, i);
    return ret;
  }

  ADTString(std::array<char,n> data, ADTStream &s)
    : ADTRaw<std::array<char,n>>(data, s) {}
  ADTString()
    : ADTRaw<std::array<char,n>>(std::array<char,n>()) {}

  void dump_as_js()
  {
    std::cout << "\"";
    for (size_t i = 0; i < n; i++) {
      auto data = this->ADTRaw<std::array<char,n>>::val();
      if (data[i] >= 0x20 && data[i] < 0x7f)
	std::cout << data[i];
      else if (data[i])
	printf("\\x%02x", uint8_t(data[i]));
    }
    std::cout << "\"";
  }
} PACKED;

class PmgrDevice {
public:
  static const bool do_dump_as_string = false;
  void dump_as_js_string() {}
  uint32_t flags;
  uint16_t parent;
  uint16_t unk1;
  uint16_t unk2;
  uint8_t addr_offset;
  uint8_t psreg_index;
  uint8_t unk3[14];
  uint16_t id;
  uint32_t unk4;
  ADTString<16> name;

  void dump_as_js()
  {
    printf("0x%08x, %d, %d, %d, %d, ",
	   flags, parent, addr_offset, psreg_index, id);
    std::cout << "\"" << name.val() << "\"";
  }
} PACKED;

class PmgrPsReg {
public:
  static const bool do_dump_as_string = false;
  void dump_as_js_string() {}
  uint32_le_t idx;
  uint32_le_t offset;
  uint32_le_t unknown;

  void dump_as_js()
  {
    idx.dump_as_js();
    printf(", ");
    offset.dump_as_js();
    printf(", ");
    unknown.dump_as_js();
  }
} PACKED;

class PmgrPowerDomain {
public:
  static const bool do_dump_as_string = false;
  void dump_as_js_string() {}
  uint32_le_t unknown[2];
  ADTString<16> string;

  void dump_as_js()
  {
    printf("0x%08x, 0x%08x, ",
	   int(size_t(unknown[0])), int(size_t(unknown[1])));
    string.dump_as_js();
  }
};

class PmgrPerfDomain {
public:
  static const bool do_dump_as_string = false;
  void dump_as_js_string() {}
  uint32_le_t unknown[3];
  ADTString<16> string;

  void dump_as_js()
  {
    printf("0x%08x, 0x%08x, ",
	   int(size_t(unknown[0])), int(size_t(unknown[1])),
	   int(size_t(unknown[2])));
    string.dump_as_js();
  }
};

class PmgrEnergyCounter {
public:
  static const bool do_dump_as_string = false;
  void dump_as_js_string() {}
  uint32_le_t unknown[2];
  ADTString<32> string;

  void dump_as_js()
  {
    printf("0x%08x, 0x%08x, ",
	   int(size_t(unknown[0])), int(size_t(unknown[1])));
    string.dump_as_js();
  }
};

class ADTPropHeader {
public:
  ADTString<32> name;
  uint24_t len;
  uint8_t flags;
} PACKED;

class ADTProp;
class ADTStringsProp;


class ADTProp : public ADTRaw<ADTPropHeader> {
public:
  std::vector<char> rawdata;
  std::string string;
  ADTProp(ADTPropHeader header, ADTStream &s) :
    ADTRaw<ADTPropHeader>(header, s)
  {
    for (size_t i = 0; i < data.len; i++) {
      rawdata.push_back(s.read<ADTRaw<char>>());
      if (rawdata.back())
	string += rawdata.back();
    }
    for (size_t i = 0; i < ((4 - data.len) & 3); i++) {
      s.read<ADTRaw<char>>();
    }
  }

  void dump_rawdata() {
    for (size_t i = 0; i < rawdata.size(); i++) {
      printf(" %02x", (uint8_t)rawdata[i]);
      if (i == 128)
	break;
    }
  }

  virtual void dump_prop()
  {
    printf(" property\n");
    std::cout << "  name " << data.name.val() << "\n";
    printf("  data");
    dump_rawdata();
    printf("\n");
  }

  virtual void dump_rawdata_as_js(std::string prefix)
  {
    for (size_t i = 0; i < rawdata.size(); i++) {
      std::cout << prefix << "." << data.name.val() << "[" << i << ":" << (i+1) << "] = [";
      printf("0x%02x", (uint8_t)rawdata[i]);
      std::cout << "]\n";
      std::cout << prefix << "." << data.name.val() << "[" << i << ":" << (i+1) << "] = \"";
      dump_escaped_char(rawdata[i]);
      std::cout << "\"\n";
    }
  }

  virtual void dump_as_js(std::string prefix)
  {
    dump_rawdata_as_js(prefix);
  }

  ADTProp *parse();
};

class ADTBlobProp : public ADTProp {
public:
  ADTBlobProp(ADTProp prop)
    : ADTProp(prop)
  {
  }

  virtual void dump_rawdata_as_js(std::string prefix)
  {
    std::cout << prefix << "." << data.name.val() << "[" << 0 << ":" << rawdata.size() << "] = [";
    if (rawdata.size() > 128)
      printf("<omitted>");
    else
      for (size_t i = 0; i < rawdata.size(); i++) {
	printf("0x%02x,", (uint8_t)rawdata[i]);
      }
    std::cout << "]\n";
  }
};

template<class T>
class ADTArrayProp : public ADTProp {
public:
  std::vector<T> vec;

  ADTArrayProp(ADTProp prop)
    : ADTProp(prop)
  {
    size_t size = rawdata.size();
    size_t count = size / sizeof(T);
    if (count * sizeof(T) != size)
      abort();

    for (size_t i = 0; i < count; i++) {
      char buf[sizeof(T)];
      for (size_t j = 0; j < sizeof(T); j++)
	buf[j] = rawdata[i * sizeof(T) + j];
      T t;
      memcpy(&t, buf, sizeof(T));
      vec.push_back(t);
    }
  }

  virtual void dump_rawdata_as_js(std::string prefix)
  {
    for (size_t i = 0; i < rawdata.size(); i += sizeof(T)) {
      std::cout << prefix << "." << data.name.val() << "[" << i << ":" << i+sizeof(T) << "] = [";
      std::cout << vec[i/sizeof(T)];
      std::cout << "]\n";
    }
  }

  virtual void dump_prop()
  {
    printf(" property\n");
    std::cout << "  name " << data.name.val() << "\n";
    for (auto t : vec) {
      std::cout << "  value " << t << "\n";
    }
  }
};

template<class T>
class ADTClassArrayProp : public ADTProp {
public:
  std::vector<T> vec;

  ADTClassArrayProp(ADTProp prop)
    : ADTProp(prop)
  {
    size_t size = rawdata.size();
    size_t count = size / sizeof(T);
    if (count * sizeof(T) != size)
      abort();

    for (size_t i = 0; i < count; i++) {
      char buf[sizeof(T)];
      for (size_t j = 0; j < sizeof(T); j++)
	buf[j] = rawdata[i * sizeof(T) + j];
      T t;
      memcpy(&t, buf, sizeof(T));
      vec.push_back(t);
    }
  }

  virtual void dump_rawdata_as_js(std::string prefix)
  {
    std::string lbr = (sizeof(T) == 4) ? "<" : "[";
    std::string rbr = (sizeof(T) == 4) ? ">" : "]";
    std::cout << prefix << "." << data.name.val() << " = " << lbr;
    for (size_t i = 0; i < rawdata.size(); i += sizeof(T)) {
      if (i)
	std::cout << " ";
      vec[i/sizeof(T)].dump_as_js();
    }
    std::cout << rbr << "\n";
  }

  virtual void dump_prop()
  {
    printf(" property\n");
    std::cout << "  name " << data.name.val() << "\n";
    for (auto t : vec) {
    }
  }
};

class ADTZeroProp : public ADTProp {
public:
  ADTZeroProp(ADTProp prop)
    : ADTProp(prop)
  {
  }

  virtual void dump_rawdata_as_js(std::string prefix)
  {
    std::cout << prefix << "." << data.name.val() << "[" << 0 << ":" << rawdata.size() << "] = {0,}\n";
  }

  virtual void dump_prop()
  {
    printf(" property\n");
    std::cout << "  name " << data.name.val() << "\n";
    std::cout << "  size (all zeroes): " << rawdata.size() << "\n";
  }
};

class ADTStringsProp : public ADTProp {
public:
  std::vector<std::string> strings;
  ADTStringsProp(ADTProp prop)
    : ADTProp(prop)
  {
    std::string cur;
    for (auto ch : rawdata) {
      if (ch == 0) {
	if (cur != "")
	  strings.push_back(cur);
	cur = std::string();
      } else {
	cur += ch;
      }
    }
  }

  virtual void dump_rawdata_as_js(std::string prefix)
  {
    std::cout << prefix << "." << data.name.val() << " = \"";
    for (size_t i = 0; i < rawdata.size(); i ++) {
      if (rawdata[i] >= 0x20 && rawdata[i] < 0x7f)
	std::cout << rawdata[i];
      else if (rawdata[i])
	printf("\\x%02x", uint8_t(rawdata[i]));
      else if (i < rawdata.size() - 1)
	std::cout << "\", \"";
    }
    std::cout << "\"\n";
  }

  virtual void dump_prop()
  {
    printf(" property\n");
    std::cout << "  name " << data.name.val() << "\n";
    for (auto str : strings)
      std::cout << "  value \"" << str << "\"\n";
  }
};

class ADTNodeHeader {
public:
  uint32_t nprops;
  uint32_t nnodes;
} PACKED;

class ADTNode : public ADTRaw<ADTNodeHeader> {
public:
  std::unordered_map<std::string,ADTProp *> props;
  std::vector<ADTNode> nodes;

  ADTNode(ADTNodeHeader header, ADTStream &s)
    : ADTRaw<ADTNodeHeader>(header) {
    for (size_t i = 0; i < data.nprops; i++) {
      ADTProp *prop = s.read<ADTProp>().parse();
      props.insert(std::make_pair(prop->data.name.val(), prop));
    }
    for (size_t i = 0; i < data.nnodes; i++)
      nodes.push_back(s.read<ADTNode>());
  }

  void dump_as_js(std::string prefix = "")
  {
    prefix += "." + props.at("name")->string;
    for (auto it : props)
      it.second->dump_as_js(prefix);
    for (auto node : nodes)
      node.dump_as_js(prefix);
  }
  void dump() {
  }
};

ADTProp *ADTProp::parse()
{
  if (rawdata.size() % 4 == 0)
    return new ADTClassArrayProp<uint32_le_t>(*this);
  return new ADTClassArrayProp<uint8_le_t>(*this);
  return new ADTStringsProp(*this);
}

int main(int argc, char **argv)
{
  FILE *f = fopen(argv[1], "r");
  if (f == NULL)
    return 1;

  void *data = malloc(1024 * 1024);
  if (data == NULL)
    return 1;
  size_t size = fread(data, 1, 1024 * 1024, f);

  void *end = (void*)((char *)data + size);

  auto adts = new ADTStream(data, end);
  auto adt = adts->read<ADTNode>();

  adt.dump_as_js("adt");

  return 0;
}
