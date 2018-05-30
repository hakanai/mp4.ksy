meta:
  id: mp4
  file-extension: mp4
  endian: be

seq:
  - id: atoms
    type: atom
    repeat: eos

types:

  atom:
    seq:
      - id: record_length
        type: u4
      - id: record_type
        type: u4
        enum: fourcc
      - id: record_data
        size: record_length - 8
        type:
          switch-on: record_type
          cases:
            fourcc::avc1: avc1
            fourcc::mdia: atom_container
            fourcc::minf: atom_container
            fourcc::moov: atom_container
            fourcc::proj: atom_container
            fourcc::stbl: atom_container
            fourcc::stsd: stsd
            fourcc::sv3d: atom_container
            fourcc::trak: atom_container
            fourcc::ytmp: ytmp 
    -webide-representation: '{record_type}'

  atom_container:
    seq:
      - id: atoms
        type: atom
        repeat: eos

  stsd:
    seq:
      - id: unknown_x0
        type: u8
      - id: atoms
        type: atom
        repeat: eos

  avc1:
    seq:
      - id: unknown_x0
        size: 78
      - id: atoms
        type: atom
        repeat: eos

  ytmp:
    seq:
      - id: unknown_x0
        type: u4
      - id: crc
        type: u4
      - id: encoding
        type: u4
        enum: fourcc
      - id: payload
        type:
          switch-on: encoding
          cases:
            fourcc::dfl8: ytmp_payload_zlib

  ytmp_payload_zlib:
    seq:
      - id: data
        size-eos: true
        process: zlib

enums:

  fourcc:

    0x61766331: avc1
    0x61766343: avc_c
    0x64666C38: dfl8
    0x64696E66: dinf
    0x65647473: edts
    0x66747970: ftyp
    0x68646C72: hdlr
    0x6D646174: mdat
    0x6D646864: mdhd
    0x6D646961: mdia
    0x6D696E66: minf
    0x6D6F6F66: moof
    0x6D6F6F76: moov
    0x6D766578: mvex
    0x6D766864: mvhd
    0x70726864: prhd
    0x70726F6A: proj
    0x73696478: sidx
    0x73743364: st3d
    0x7374626C: stbl
    0x7374636F: stco
    0x73747363: stsc
    0x73747364: stsd
    0x73747373: stss
    0x7374737A: stsz
    0x73747473: stts
    0x73763364: sv3d
    0x73766864: svhd
    0x746B6864: tkhd
    0x7472616B: trak
    0x75756964: uuid
    0x766D6864: vmhd
    0x79746D70: ytmp
