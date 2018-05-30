meta:
  id: mp4
  file-extension: mp4
  endian: be

seq:
  - id: boxes
    type: box
    repeat: eos

types:

  box:
    seq:
      - id: length
        type: u4
      - id: type
        type: u4
        enum: fourcc
      - id: data
        size: length - 8
        type:
          switch-on: type
          cases:
            fourcc::avc1: avc1
            fourcc::dinf: box_container
            fourcc::dref: dref
            fourcc::edts: box_container
            fourcc::mdia: box_container
            fourcc::minf: box_container
            fourcc::moov: box_container
            fourcc::proj: box_container
            fourcc::stbl: box_container
            fourcc::stsd: stsd
            fourcc::sv3d: box_container
            fourcc::trak: box_container
            fourcc::uuid: uuid
            fourcc::ytmp: ytmp 
    -webide-representation: '{type}'

  box_container:
    seq:
      - id: boxes
        type: box
        repeat: eos

  dref:
    seq:
      - id: unknown_x0
        size: 8
      - id: boxes
        type: box
        repeat: eos

  stsd:
    seq:
      - id: unknown_x0
        type: u8
      - id: boxes
        type: box
        repeat: eos

  avc1:
    seq:
      - id: unknown_x0
        size: 78
      - id: boxes
        type: box
        repeat: eos

  # From old RFC for spherical video
  # https://github.com/google/spatial-media/blob/master/docs/spherical-video-rfc.md
  uuid:
    seq:
      - id: uuid
        size: 16
      - id: xml_metadata
        size-eos: true

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
        #process: zlib

enums:

  fourcc:
    0x61766331: avc1
    0x61766343: avc_c
    0x64666C38: dfl8
    0x64696E66: dinf
    0x64726566: dref
    0x65647473: edts
    0x656C7374: elst
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
    0x75726C20: url
    0x75756964: uuid
    0x766D6864: vmhd
    0x79746D70: ytmp
