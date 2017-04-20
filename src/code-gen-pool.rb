original_list_size = CodeGen::List.size

class Python_R_Ratfor_Rc_REXX < CodeGen
  After = Python_R_Ratfor_REXX
  Obsoletes = Python_R_Ratfor_REXX
  Name = ["Python", "R", "Ratfor", "rc", "REXX"]
  File = ["QR.py", "QR.R", "QR.ratfor", "QR.rc", "QR.rexx"]
  Cmd = [
    "python QR.py > OUTFILE",
    "R --slave -f QR.R > OUTFILE",
    "ratfor -o QR.ratfor.f QR.ratfor && gfortran -o QR QR.ratfor.f && ./QR > OUTFILE",
    "rc QR.rc > OUTFILE",
    "rexx ./QR.rexx > OUTFILE"
  ]
  Apt = ["python", "r-base", "ratfor", "rc", "regina-rexx"]
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        print('cat("')\n
        for c in"".join(["echo 'say ''%s'''\\n"%l for l in#{E[d[d[PREV,?'],?']]}.split("\\n")]):
          print('r=fput(char(%d))'%ord(c))\n
        print('end\\n")')#
      )
    END
  end
end

class Promela < CodeGen
  After = Prolog
  Name = "Promela (Spin)"
  File = "QR.pr"
  Cmd = "spin -T QR.pr > OUTFILE"
  Apt = "spin"
  Code = %q("init{#{f(PREV,7){"printf#{d[$S,?%]};"}}}")
end

class Perl6 < CodeGen
  After = Perl
  Name = "Perl 6"
  File = "QR.pl6"
  Cmd = "perl6 QR.pl6 > OUTFILE"
  Apt = "rakudo"
  Code = %q("$_='#{Q[PREV.gsub(B,"\x7f"),?']}';s:g/\\\\x7f/\\\\\\\\/;print $_")
end

class Perl
  Name = "Perl 5"
end

class Parser3 < CodeGen
  After = PARIGP
  Name = "Parser 3"
  File = "QR.p"
  Cmd = "parser3 QR.p > OUTFILE"
  Apt = "parser3-cgi"
  Code = %q("$console:line[#{PREV.gsub(/[:;()]/){?^+$&}}]")
end

#class Nim_NVSPL2 < CodeGen
#  After = Nim
#  Obsoletes = Nim
#  File = ["QR.nim", "QR.nvspl2"]
#  Cmd = ["nim c QR.nim && ./QR > OUTFILE", "ruby vendor/nvspl2.rb QR.nvspl2 > OUTFILE"]
#  Apt = ["nim", nil]
#  Code = %q(%((for i, c in#{E[PREV]}:echo ",",int(c),"CO");echo "Q"))
#end

class NesC < CodeGen
  After = Neko
  Name = "nesC"
  File = "QR.nc"
  Cmd = "nescc -o QR QR.nc && ./QR > OUTFILE"
  Apt = "nescc"
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        #include<stdio.h>\n
        module QR{}implementation{
          int main()__attribute__((C,spontaneous)){
            puts#{E[PREV]};
            return 0;
        } }
      )
    END
    # avoid "}}" because of Mustache
  end
end

class Mustache_NASM < CodeGen
  After = MSIL
  Obsoletes = NASM
  File = ["QR.mustache", "QR.asm"]
  Cmd = [
    "mustache QR.mustache QR.mustache > OUTFILE",
    "nasm -felf QR.asm && ld -m elf_i386 -o QR QR.o && ./QR > OUTFILE",
  ]
  Apt = ["ruby-mustache", "nasm"]
  def code
    <<-'END'.lines.map {|l| l.strip.gsub("^^^", " ") }.join("\\n")
      "m{{!: x
      qr: |-
      ^^^:db\x60#{e[s=PREV]}\x60
      ^^^global _start
      ^^^_start:mov edx,#{s.size}
      ^^^mov ecx,m
      ^^^mov ebx,1
      ^^^mov eax,4
      ^^^int 128
      ^^^mov ebx,0
      ^^^mov eax,1
      ^^^int 128
      x: |
      ^^^}}{{{qr}}}"
    END
  end
end

class M4 < CodeGen
  After = Lua
  File = "QR.m4"
  Cmd = "m4 QR.m4 > OUTFILE"
  Apt = "m4"
  Code = %q("changequote(<@,@>)\ndefine(p,<@#{PREV}@>)\np")
end

class Julia_Ksh_LazyK_Lisaac < CodeGen
  After = Jq
  Obsoletes = Julia_LazyK_Lisaac
  Name = ["Julia", "ksh", "Lazy K", "Lisaac"]
  File = ["QR.jl", "QR.ksh", "QR.lazy", "qr.li"]
  Cmd = [
    "julia QR.jl > OUTFILE",
    "ksh QR.ksh > OUTFILE",
    "lazyk QR.lazy > OUTFILE",
    "lisaac qr.li && ./qr > OUTFILE",
  ]
  Apt = ["julia", "ksh", nil, "lisaac"]
  def code
    lazyk = ::File.read(::File.join(__dir__, "lazyk-boot.dat"))
    lazyk = lazyk.tr("ski`","0123").scan(/.{1,3}/).map do |n|
      n = n.reverse.to_i(4)
      [*93..124,*42..73][n]
    end.pack("C*")
    lazyk = lazyk.gsub(/[ZHJK\^`~X]/) {|c| "\\x%02x" % c.ord }
    <<-'END'.lines.map {|l| l.strip }.join.sub("LAZYK"){lazyk}
      %(
        A=print;
        A("echo 'k`");
        [
          (
            A("``s"^8*"i");
            for j=6:-1:0;
              x=(Int(c)>>j)%2+1;
              A("`"*"kki"[x:x+1])
            end
          )for c in join([
            "SectionHeader+name:=QR;SectionPublic-main<-(";
            ["\\"$(replace(replace(s,"\\\\","\\\\\\\\"),"\\"","\\\\\\""))\\".print;"for s=matchall(r".{1,99}",#{Q[E[PREV]]})];
            ");"
          ],"\\n")
        ];
        [
          for i=0:2:4;
            x=((Int(c)%83-10)>>i)%4+1;
            A("ski`"[x:x])
          end for c in"LAZYK"
        ];
        A("'")
      )
    END
  end
end

class LLVMAsm
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        @s=global[#{i=(s=PREV).size+1}x i8]
          c"#{s.gsub(/[\\"\n\t]/){"\\%02X"%$&.ord}}\\00"
        declare i32@puts(i8*)
        define i32@main(){
          %1=call i32@puts(i8*getelementptr([#{i}x i8],[#{i}x i8]*@s,i32 0,i32 0))
          ret i32 0
        }
      )
    END
  end
end

class LiveScript < CodeGen
  After = Julia_Ksh_LazyK_Lisaac
  Name = "LiveScript"
  File = "QR.ls"
  Cmd = "lsc QR.ls > OUTFILE"
  Apt = "livescript"
  Code = %q("console.log"+Q[E[PREV],?#])
end

class JavaScript_Jq_JSFuck < CodeGen
  After = Java_
  Obsoletes = [JavaScript, Jq]
  File = ["QR.js", "QR.jq", "QR.jsfuck"]
  Cmd = [
    "$(JAVASCRIPT) QR.js > OUTFILE",
    "jq -r -n -f QR.jq > OUTFILE",
    "!$(JAVASCRIPT) --stack_size=100000 QR.jsfuck > OUTFILE",
  ]
  Apt = ["nodejs", "jq", "nodejs"]
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        P={0:'[+[]]',m:'((+[])'+(C="['constructor']")+"+[])['11']"};
        for(R in B=
          (
            '![]@!![]@[][[]]@'+
            (A="[]['fill']")+
            "@([]+[])['fontcolor']([])@(+('11e20')+[])['split']([])@"+
            A+C+"('return escape')()("+A+')'
          ).split('@')
        )
          for(E in D=eval(G='('+B[R]+'+[])'))
            P[T=D[E]]=P[T]||G+"['"+E+"']";
        for(G='[',B=0;++B<36;)
          P[D=B.toString(36)]=
            B<10?
              (G+='+!+[]')+']'
            :
              P[D]||"(+('"+B+"'))['to'+([]+[])"+C+"['name']]('36')";
        A+=C+"('console.log(unescape(\\"";
        for(E in G=#{E[PREV]})
          A+="'+![]+'"+G.charCodeAt(E).toString(16);
        for(A+="\\".replace(/'+![]+'/g,\\"%\\")))')()",R=0;R<9;R++)
          A=A.replace(/'.*?'/g,function(B){
            T=[];
            for(E=1;B[E+1];)
              T.push(P[B[E++]]);
            return T.join('+')
          });
        console.log('"'+A+'"')
      )
    END
  end
end

class Gri_Groovy_Gzip < CodeGen
  After = Go_GPortugol_Grass
  Obsoletes = Groovy
  File = ["QR.gri", "QR.groovy", "QR.gz"]
  Cmd = ["gri QR.gri > OUTFILE", "groovy QR.groovy > OUTFILE", "gzip -cd QR.gz > OUTFILE"]
  Apt = ["gri", "groovy", "gzip"]
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        show "
          z=new java.util.zip.GZIPOutputStream(System.out);
          z.write('#{PREV.tr(?"+B,"!~")}'.tr('~!','\\\\\\\\\\u0022')as byte[]);
          z.close()
        "\n
      )
    END
  end
end

class GolfScript_GPortugol_Grass < CodeGen
  After = Go_GPortugol_Grass
  Obsoletes = Go_GPortugol_Grass
  Name = ["GolfScript", "G-Portugol", "Grass"]
  File = ["QR.gs", "QR.gpt", "QR.grass"]
  Cmd = ["ruby vendor/golfscript.rb QR.gs > OUTFILE", "gpt -o QR QR.gpt && ./QR > OUTFILE", "ruby vendor/grass.rb QR.grass > OUTFILE"]
  Apt = [nil, "gpt", nil]
  def code
    r = <<-'END'.lines.map {|l| l.strip }.join
      %(
        @@BASE@@:j;
        {
          119:i;
          {
            206i-:i;
            .48<{71+}{[i]\\48-*}if
          }%
        }:t;
        "algoritmo QR;in"[195][173]++'cio imprima("'
        @@PROLOGUE@@
        "#{e[PREV]}"
        {
          "W""w"@j 1+:j\\- @@MOD@@%1+*
        }%
        @@EPILOGUE@@
        '");fim'
      )
    END
    mod, prologue, epilogue = ::File.read(::File.join(__dir__, "grass-boot.dat")).lines
    prologue += "t"
    epilogue += "t"
    prologue = prologue.gsub(/(\/12131)+/) { "\"t\"/12131\"t #{ $&.size / 6 }*\"" }
    mod = mod.to_i
    r.gsub(/@@\w+@@/, {
      "@@PROLOGUE@@" => prologue.chomp,
      "@@EPILOGUE@@" => epilogue.chomp,
      "@@BASE@@" => 119 + mod - 1,
      "@@MOD@@" => mod,
    })
  end
end

class Go < CodeGen
  After = Gnuplot
  File = "QR.go"
  Cmd = "go run QR.go > OUTFILE"
  Apt = "golang"
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        package main;
        import"fmt";
        func main(){
          fmt.Print#{E[PREV]};
        }
      )
    END
  end
end

class GDB < CodeGen
  After = GAP
  File = "QR.gdb"
  Cmd = "gdb -q -x QR.gdb > OUTFILE"
  Apt = "gdb"
  Code = %q(%(printf"#{e[d[PREV,?%]]}"\nquit))
end

class Flex < CodeGen
  After = FALSELang
  File = "QR.fl"
  Cmd = "flex -o QR.fl.c QR.fl && gcc -o QR QR.fl.c && ./QR > OUTFILE"
  Apt = "flex"
  Code = %q("%option noyywrap\n%%\n%%\nint main(){puts#{E[PREV]};}")
end

class Curry < CodeGen
  After = CommonLisp
  File = "QR.curry"
  Cmd = "touch ~/.pakcsrc && runcurry QR.curry > OUTFILE"
  Apt = "pakcs"
  Code = %q("main=putStr"+E[PREV])
end

class CoffeeScript < CodeGen
  Cmd.replace "coffee --nodejs --stack_size=100000 QR.coffee > OUTFILE"
end

class Clojure_CMake_Cobol < CodeGen
  After = Clojure_Cobol
  Obsoletes = Clojure_Cobol
  File = ["QR.clj", "QR.cmake", "QR.cob"]
  Cmd = [
    "clojure QR.clj > OUTFILE",
    "cmake -P QR.cmake > OUTFILE",
    "cobc -O2 -x QR.cob && ./QR > OUTFILE",
  ]
  Apt = ["clojure", "cmake", "open-cobol"]
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        (doseq[s
          (lazy-cat
            ["IDENTIFICATION DIVISION."
             "PROGRAM-ID. QR."
             "PROCEDURE DIVISION."
             'DISPLAY]
             (map #(str
                  "    \\""
                  (.replace %1"\\"""\\"\\"")
                  "\\"&")
               (re-seq #".{1,45}"
                  "#{e[PREV]}"))
             ["    \\" \\"."
              "STOP RUN."])]
          (println(str
            "message(STATUS \\"     "
            (.replace(.replace(str s)"\\\\""\\\\\\\\")"\\"""\\\\\\"")
            "\\")")))
        )
    END
  end
end

class C < CodeGen
  c = C.new.code.gsub("99999", "999999")
  define_method(:code) { c }
end

class Bash_Bc_Befunge_BLC8_Brainfuck < CodeGen
  After = Awk_Bc_Befunge_BLC8_Brainfuck
  Obsoletes = Awk_Bc_Befunge_BLC8_Brainfuck
  Name = ["bash", "bc", "Befunge", "BLC8", "Brainfuck"]
  File = ["QR.bash", "QR.bc", "QR.bef", "QR.Blc", "QR.bf"]
  Cmd = [
    "bash QR.bash > OUTFILE",
    "BC_LINE_LENGTH=4000000 bc -q QR.bc > OUTFILE",
    "cfunge QR.bef > OUTFILE",
    "ruby vendor/blc.rb < QR.Blc > OUTFILE",
    "$(BF) QR.bf > OUTFILE",
  ]
  Apt = ["bash", "bc", nil, nil, "bf"]
  def code
    blc = ::File.read(::File.join(__dir__, "blc-boot.dat"))
    <<-'END'.lines.map {|l| l.strip }.join.sub("BLC", [blc].pack("m0"))
      %(
        echo '
          define void f(n){
            "00g,";
            for(m=1;m<256;m*=2){
              "00g,4,:";
              if(n/m%2)"4+";
              ",";
            };
            "4,:,"
          }
          "389**6+44*6+00p45*,";
        ';
        printf "f(%d);\n" `echo '#{d[PREV,B].gsub(?',%('"'"'))}'|od -An -tuC`;
        printf '"4,:,';
        printf '%s\\\\8*+\\\\88**+,' `echo BLC|base64 -d|od -An -toC`;
        printf "@\\"\nquit"
      )
    END
  end
end

class Awk < CodeGen
  After = ATS
  Name = "Awk"
  File = "QR.awk"
  Cmd = "awk -f QR.awk > OUTFILE"
  Apt = "gawk"
  Code = %q("BEGIN{print#{E[PREV]}}")
end

class AspectJ < CodeGen
  After = ALGOL68_Ante
  File = "QR.aj"
  Cmd = "ajc QR.aj && java QR > OUTFILE"
  Apt = "aspectj"
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        class QR{
          #$L void main(String[]v){
            System.out.print(#{E[PREV.gsub(B,?^)]}.replace("^","\\\\"));
          }
        }
      )
    END
  end
end

class ALGOL68_Ante_AspectCpp < CodeGen
  After = ALGOL68_Ante
  Obsoletes = ALGOL68_Ante
  Name = ["ALGOL 68", "Ante", "AspectC++"]
  File = ["QR.a68", "QR.ante", "QR.cc"]
  Cmd = [
    "a68g QR.a68 > OUTFILE",
    "ruby vendor/ante.rb QR.ante > OUTFILE",
    "ag++ -o QR QR.cc && ./QR > OUTFILE",
  ]
  Apt = ["algol68g", nil, "aspectc++"]
  def code
    <<-'end'.lines.map {|l| l.strip }.join
      %W[
        STRINGz:= 226+ 153,a:=z+ 166,b:=a+"2"+z+ 160,c:=b+"8"+z+ 165,t:="#include<iostream>"+ (10)+"int"+ (32)+"main(){puts#{d[E[PREV]]};}";
        FORiTO\ UPBtDO\ INTn:=ABSt[i];
          print( (50+n%64)+c+ (50+n%8MOD8)+c+ (50+nMOD8)+b+"J"+a)
        OD
      ]*"REPR"
    end
  end
end

class AFNIX_Aheui < CodeGen
  After = AFNIX
  Obsoletes = AFNIX
  File = ["QR.als", "QR.aheui"]
  Cmd = ["axi QR.als > OUTFILE", "go run vendor/goaheui/main.go QR.aheui > OUTFILE"]
  Apt = ["afnix", nil]
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        interp:library"afnix-sio"\n
        trans O(n){
          trans o(afnix:sio:OutputTerm)\n
          o:write(Byte(+ 128 n))
        }\n
        trans f(v n){\n
          O(+(/ n 64)107)\n
          O(n:mod 64)\n
          O v
        }\n
        trans D(n){
          if(< n 4){
            f(+(* 6 n)9)48
          }{
            if(n:odd-p){
              D(- n 3)\n
              f 27 48\n
              f 36 11
            }{
              D(/ n 2)\n
              f 21 48\n
              f 48 20
            }
          }
        }\n
        trans S"#{e[PREV]}"\n
        trans c 0\n
        do{
          D(Integer(S:get c))\n
          f 35 39
        }(<(c:++)(S:length))\n
        f 24 149
      )
    END
  end
end

class Ada < CodeGen
  def code
    <<-'END'.lines.map {|l| l.strip }.join.gsub("$$$", " ")
      %(
        with Ada.Text_Io;
        procedure qr is$$$
        begin$$$
          Ada.Text_Io.Put("#{d[PREV].gsub(N,'"&Character'+?'+'Val(10)&"')}");
        end;
      )
    END
  end
end

class Zsh < CodeGen
  After = Zoem
  Name = "zsh"
  File = "QR.zsh"
  Cmd = "zsh QR.zsh > OUTFILE"
  Apt = "zsh"
  Code = %q("echo -E $'#{Q[Q[PREV,B],?']}'")
end

class Yabasic < CodeGen
  After = XSLT
  File = "QR.yab"
  Cmd = "yabasic QR.yab > OUTFILE"
  Apt = "yabasic"
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        sub f(s$,n)
          print(s$);:
          for i=1to n print("\\\\");:
          next:
        end sub:
        f("#{V[e[PREV],'",','):f("']}",0)
      )
    END
  end
end

class VimScript < CodeGen
  After = Verilog
  Name = ["Vimscript"]
  Apt = "vim"
  File = "QR.vim"
  Cmd = "vim -EsS QR.vim > OUTFILE"
  Code = %q("let s=#{E[PREV]}\nput=s\nprint\nqa!")
end

class TypeScript_Unlambda < CodeGen
  After = Tcl_Thue_Unlambda
  File = ["QR.ts", "QR.unl"]
  Cmd = ["tsc --outFile QR.ts.js QR.ts && $(JAVASCRIPT) QR.ts.js > OUTFILE", "ruby vendor/unlambda.rb QR.unl > OUTFILE"]
  Apt = ["node-typescript", nil]
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      "let s=#{E[PREV]},i=0,t='k';while(s[i])t='\\x60.'+s[i++]+t;console.log(t)"
    END
  end
end

class Tcsh_Thue < CodeGen
  After = Tcl_Thue_Unlambda
  Name = ["tcsh", "Thue"]
  File = ["QR.tcsh", "QR.t"]
  Cmd = ["tcsh QR.tcsh > OUTFILE", "ruby vendor/thue.rb QR.t > OUTFILE"]
  Apt = ["tcsh", nil]
  Code = %q(%(echo 'a::=~#{Q[Q[PREV,B],?!].gsub(?',%('"'"'))}'"\\\\n::=\\\\na"))
end

class Tcl < CodeGen
  After = Tcl_Thue_Unlambda
  Obsoletes = Tcl_Thue_Unlambda
  File = "QR.tcl"
  Cmd = "tclsh QR.tcl > OUTFILE"
  Apt = "tcl"
  Code = %q(%(puts "#{Q[e[PREV],/[\[\]$]/]}"))
end

class Scilab_Sed_Shakespeare_SLang < CodeGen
  After = Scheme
  Obsoletes = [Scilab, Shell_SLang]
  Name = ["Scilab", "sed", "Shakespeare", "S-Lang"]
  File = ["QR.sci", "QR.sed", "QR.spl", "QR.sl"]
  Cmd = [
    "scilab -nwni -nb -f QR.sci > OUTFILE",
    "sed -E -f QR.sed QR.sed > OUTFILE",
    "./vendor/local/bin/spl2c < QR.spl > QR.spl.c && gcc -o QR -I ./vendor/local/include -L ./vendor/local/lib QR.spl.c -lspl -lm && ./QR > OUTFILE",
    "slsh QR.sl > OUTFILE",
  ]
  Apt = ["scilab", "sed", nil, "slsh"]
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        printf("
          1d;
          s/.//;
          s/1/ the sum of a son and0/g;
          s/0/ twice/g;
          s/2/You are as bad as/g;
          s/3/ a son!Speak your mind!/g\\n
          #The Relay of Quine.\\n
          #Ajax, a man.\\n
          #Ford, a man.\\n
          #Act i: Quine.\\n
          #Scene i: Relay.\\n
          #[Enter Ajax and Ford]\\n
          #Ajax:\\n
          #");
        function[]=f(s);
          for i=1:2:length(s),
            printf("2%s3",part(dec2bin(hex2dec(part(s,i:i+1))),$:-1:2)),
          end;
        endfunction\n
        #{
          s,v=rp[PREV,127..255];
          f(
            %(
              variable s=`#{s.gsub(/.{1,234}/){$&.gsub("`",%(`+"`"+`))+"`+\n`"}}`,i;
              for(i=0;i<129;i++)
                s=strreplace(
                  s,
                  pack("C",255-i),
                  substrbytes(`#{v[0,99]}`+\n`#{v[99..-1]}`,i*2+1,2));
              printf("%s",s)
            ),7
          ){
            "f('%s')\n"%$s.unpack("H*")
          }
        }
        printf("\\n#[Exeunt]");
        quit
      )
    END
  end
end

class Rust < CodeGen
  After = Ruby
  File = "QR.rs"
  Cmd = "rustc QR.rs && ./QR > OUTFILE"
  Apt = "rustc"
  Code = %q(%(fn main(){print!("{}",#{E[PREV]});}))
end

CodeGen::List.slice!(original_list_size..-1).each do |s|
  i = CodeGen::List.find_index(s::After)
  CodeGen::List.insert(i, s)
  [*s::Obsoletes].each {|s_| CodeGen::List.delete(s_) } if defined?(s::Obsoletes)
end
