class CategorieComptable < ActiveRecord::Base
  belongs_to :entree_journal
  has_one :tier, :dependent => :destroy
  has_many :facture
  has_one :compte_bancaire, :dependent => :destroy
  belongs_to :categorie_comptable
  has_many :categorie_comptables

  validates :numero, :uniqueness => true
 
  # récupère un tableau de tous les parents de la catégorie dans l'arborescence de catégorie_comptable 
  def parents
    parents = []
    parent = self
    while parent.niveau != 1
      parent = parent.categorie_comptable
      parents.push(parent)
    end
    return parents
  end

  # Détermine si la catégorie est une classe, une sous classe ou une catégorie
  def libelle
    case niveau
      when 1
        return "Classe"
      when 2
        return "Sous-classe"
      else
      return "Categorie comptable"
    end
  end

  # Permet de renvoyer le nom et le numéro ensemble séparé d'un tiret
  def numero_nom
    "#{numero} - #{nom}"
  end

  #retourne le prochain numéro de catégorie à utiliser dans la sous classe num
  def last(num)
    last = CategorieComptable.find_by_numero(num).categorie_comptables.order("numero ASC").last
    if (last.nil?)
      return num*10000 + 1 #pour avoir 4 zeros en plus
    else
      return last.numero + 1
    end
  end

  # permet de créer l'arborescence entre les catégories comptables (à appeler à chaque fois qu'on crée une catégorie comptable)
  def classer
    self.niveau = self.numero.to_s.length

    num = self.numero.to_s

    case self.niveau
      when 1
      when 2
        self.categorie_comptable = CategorieComptable.find_by_numero(num[0].to_i)
      else
        self.categorie_comptable = CategorieComptable.find_by_numero(num[0..1].to_i)
    end
  end


end
