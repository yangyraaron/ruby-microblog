module ApplicationHelper
  def append_query_param(path,params)
    url = "#{path}"
    if(url=~/[\?]{1}[^\?]+/)
      url<<"&"
    else
      url<<"?"
    end

    i=0
    params.each do |key,value|
      unless i==0
        url <<"&#{key}=#{value}"
      else
        url<<"#{key}=#{value}"
      end

      i=1
    end

    url

  end

  def caculate_total_page(count,size)
    m_value = count % size

    unless m_value==0
      total=(count/size)+1
    else
      total=count/size
    end
  end

  def get_content(io)
    content=[]
    io.each_byte do |b|
      content<<b
    end

    content
  end
end
