class Bildirim{
  String ekilen;
  int begeniSayisi;

  Bildirim(this.ekilen, this.begeniSayisi);
}

class BildirimListe{
  List<Bildirim> _bildirimListesi;

  BildirimListe(){
    this._bildirimListesi=[];

    _bildirimListesi.add(Bildirim("Çam Fidanı", 211));
    _bildirimListesi.add(Bildirim("Mısır", 60));
    _bildirimListesi.add(Bildirim("Kestane", 160));
    _bildirimListesi.add(Bildirim("Portakal", 250));
  }

  List<Bildirim> get getBildirimListe=>_bildirimListesi;
}