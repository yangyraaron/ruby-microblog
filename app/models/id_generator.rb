require 'thread'

class IdGenerator
  #server id
  @@work_id=0
  #the start time of caculating id
  @@start_epoch=1303895660503

  #length of server id
  @@work_id_bits=10
  #the max server id 2^10-1=1023
  @@max_work_id=-1^-1<<@@work_id_bits

  #sequence value
  @@sequence=0
  #the length of sequence
  @@sequence_bits=12
  #sequence mask=2^12-1=4095
  @@sequence_mask=-1^-1<<@@sequence_bits

  #the work id value should left shift 12
  @@work_id_shift=@@sequence_bits
  #the timestamp value should left shift 22
  @@timestamp_shift=@@sequence_bits+@@work_id_bits

  @@last_timestamp=-1

  # a thread lock for safty
  @lock= Mutex.new

  def self.generate_id
    @lock.synchronize{
      timestamp = time_gen

      #if the timestamp is same
      if timestamp==@@last_timestamp
        #increase the sequence
        @@sequence = @@sequence+1 & @@sequence_mask
        #if the sequence is greater than 4095
        if @@sequence==0
          #wait next timestamp
          timestamp = tilNextMillis(@@last_timestamp)
        end
      else
        @@sequence = 0
      end

      if timestamp<@@last_timestamp
        raise "clock has been changed,can't generate id"
      end

      @@last_timestamp = timestamp

      puts "#{timestamp}"
      timestamp-@@start_epoch<<@@timestamp_shift|@@work_id<<@@work_id_shift|@@sequence
    }
  end

  def self.tilNextMillis(current_timstamp)
    timestamp = time_gen

    until timestamp>current_timstamp
      timestamp = time_gen
    end

    timestamp
  end

  def self.time_gen
    (Time.now.to_f*1000).to_i
  end

end
